"""Draw a digit with the mouse and classify it on the PYNQ-Z2.

    python software/draw_digit_demo.py              # board over USB-JTAG
    python software/draw_digit_demo.py --backend model   # no board: Python model

The drawing is reduced to 8x8 with values 0-16 (mini_accel/preprocess.py),
quantized to INT8, and classified by a 64 -> 32 -> 10 network trained on MNIST
put through the same preprocessing. Both layers run on the accelerator. Each run's weight
and activation words and the results returned by the board are shown as they
arrive. The board's 10 class scores are shown next to the scores computed in
software, and the predicted digit is shown in binary on the board's 4 LEDs.
"""

from __future__ import annotations

import argparse
import queue
import sys
import threading
import tkinter as tk
from pathlib import Path
from tkinter import font as tkfont

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))

from mini_accel import backends  # noqa: E402
from mini_accel.inference import infer  # noqa: E402
from mini_accel.model import train_quantized  # noqa: E402
from mini_accel.packing import to_signed32  # noqa: E402
from mini_accel.preprocess import to_digits_format  # noqa: E402

CANVAS = 320
BRUSH = 20
REPO = Path(__file__).resolve().parents[1]


class Demo:
    def __init__(self, root: tk.Tk, backend: str, bitstream: Path):
        self.root, self.backend, self.bitstream = root, backend, bitstream
        self.model = train_quantized("mnist8")
        self.session: dict = {}          # one JTAG session shared by both modes
        self.programmed = False
        self.mode = tk.StringVar(value="host")
        self.cpu = None
        if backend == "jtag":
            from mini_accel.cpu_host import CpuRunner
            from mini_accel.firmware import build
            self.execute = lambda runs, **kw: backends.run_jtag(runs, bitstream, session=self.session, **kw)
            self.cpu = CpuRunner(build(self.model), "jtag", bitstream)
            self.cpu.session = self.session
        else:
            self.execute = backends.run_model
        self.events: queue.Queue = queue.Queue()
        self.busy = False
        self.ink = np.zeros((CANVAS, CANVAS), dtype=np.uint8)
        self.last = None

        root.title("Mini accelerator: draw a digit")
        big = tkfont.Font(size=40, weight="bold")
        mono = tkfont.Font(family="Consolas", size=9)

        left = tk.Frame(root, padx=10, pady=10)
        left.grid(row=0, column=0, sticky="n")
        tk.Label(left, text="Draw a digit (0-9)").pack(anchor="w")
        self.canvas = tk.Canvas(left, width=CANVAS, height=CANVAS, bg="black", cursor="crosshair")
        self.canvas.pack()
        self.canvas.bind("<B1-Motion>", self.draw)
        self.canvas.bind("<ButtonRelease-1>", lambda e: setattr(self, "last", None))
        buttons = tk.Frame(left)
        buttons.pack(fill="x", pady=6)
        self.run_btn = tk.Button(buttons, text="Run on board" if backend == "jtag" else "Run (model)",
                                 command=self.run, width=16)
        self.run_btn.pack(side="left")
        tk.Button(buttons, text="Clear", command=self.clear, width=10).pack(side="left", padx=6)
        if backend == "jtag":
            modes = tk.LabelFrame(left, text="Who drives the accelerator")
            modes.pack(fill="x", pady=4)
            tk.Radiobutton(modes, text="PC over USB (shows every run)", variable=self.mode,
                           value="host").pack(anchor="w")
            tk.Radiobutton(modes, text="My CPU on the FPGA (PC sends only the image)", variable=self.mode,
                           value="cpu").pack(anchor="w")
        tk.Label(left, text="What the accelerator sees (8x8, values 0-16)").pack(anchor="w", pady=(8, 0))
        self.preview = tk.Canvas(left, width=160, height=160, bg="black")
        self.preview.pack(anchor="w")

        mid = tk.Frame(root, padx=10, pady=10)
        mid.grid(row=0, column=1, sticky="n")
        tk.Label(mid, text="Accelerator runs: weight words -> board, activation words -> board, "
                           "dot products <- board").pack(anchor="w")
        self.log = tk.Text(mid, width=78, height=30, font=mono, bg="#111", fg="#ddd")
        self.log.pack()
        self.status = tk.Label(mid, text="", anchor="w")
        self.status.pack(fill="x")

        right = tk.Frame(root, padx=10, pady=10)
        right.grid(row=0, column=2, sticky="n")
        tk.Label(right, text="Predicted digit").pack()
        self.pred = tk.Label(right, text="-", font=big, width=3)
        self.pred.pack()
        tk.Label(right, text="Class scores: board vs. expected (software)").pack(pady=(10, 0))
        self.scores = tk.Text(right, width=38, height=13, font=mono)
        self.scores.pack()
        self.verdict = tk.Label(right, text="", font=tkfont.Font(size=11, weight="bold"))
        self.verdict.pack(pady=6)

        self.root.after(50, self.poll)

    def draw(self, e: tk.Event) -> None:
        if self.busy:
            return
        x, y = e.x, e.y
        if self.last:
            self.canvas.create_line(*self.last, x, y, fill="white", width=2 * BRUSH, capstyle="round")
        self.canvas.create_oval(x - BRUSH, y - BRUSH, x + BRUSH, y + BRUSH, fill="white", outline="white")
        steps = 1 if not self.last else max(1, int(np.hypot(x - self.last[0], y - self.last[1]) / 3))
        for t in np.linspace(0, 1, steps + 1):
            px = int(x if not self.last else self.last[0] + t * (x - self.last[0]))
            py = int(y if not self.last else self.last[1] + t * (y - self.last[1]))
            yy, xx = np.ogrid[-py:CANVAS - py, -px:CANVAS - px]
            self.ink[xx * xx + yy * yy <= BRUSH * BRUSH] = 1
        self.last = (x, y)

    def clear(self) -> None:
        if self.busy:
            return
        self.canvas.delete("all")
        self.preview.delete("all")
        self.ink[:] = 0
        self.log.delete("1.0", "end")
        self.scores.delete("1.0", "end")
        self.pred.config(text="-")
        self.verdict.config(text="")
        self.status.config(text="")

    def show_preview(self, img: np.ndarray) -> None:
        self.preview.delete("all")
        for r in range(8):
            for c in range(8):
                g = int(img[r, c] / 16 * 255)
                self.preview.create_rectangle(c * 20, r * 20, c * 20 + 20, r * 20 + 20,
                                              fill=f"#{g:02x}{g:02x}{g:02x}", outline="#333")

    def run(self) -> None:
        img = to_digits_format(self.ink)
        if img is None or self.busy:
            return
        self.show_preview(img)
        x_q = np.clip(np.round(img / self.model.x_scale), -128, 127).astype(np.int8)[None, :].reshape(1, 64)
        self.log.delete("1.0", "end")
        self.scores.delete("1.0", "end")
        self.verdict.config(text="")
        self.pred.config(text="...")
        self.status.config(text="Running...")
        self.busy = True
        self.run_btn.config(state="disabled")
        threading.Thread(target=self.worker, args=(x_q,), daemon=True).start()

    def worker(self, x_q) -> None:
        if self.mode.get() == "cpu":
            return self.cpu_worker(x_q)
        try:
            expected = self.model.golden_logits(x_q)[0]
            last = len(self.model.layers) - 1
            layer = [-1]

            def execute(runs):
                layer[0] += 1
                emit = lambda i, res: self.events.put(("run", layer[0], i, runs[i], res))  # noqa: E731
                if self.backend == "model":
                    results, stats = self.execute(runs)
                    for i, res in enumerate(results):
                        emit(i, res)
                    return results, stats
                if not self.programmed:
                    self.events.put(("status", "Programming the FPGA over JTAG (first run only)..."))
                    self.programmed = True
                leds = int(np.argmax(expected)) if layer[0] == last else None
                return self.execute(runs, on_result=emit, leds=leds)

            logits, info = infer(self.model, x_q, execute)
            self.events.put(("done", logits[0], expected, info))
        except Exception as exc:  # shown in the window
            self.events.put(("error", str(exc)))

    def poll(self) -> None:
        while not self.events.empty():
            ev = self.events.get()
            if ev[0] == "status":
                self.status.config(text=ev[1])
            elif ev[0] == "run":
                _, layer, i, run, res = ev
                if i == 0:
                    self.log.insert("end", f"--- layer {layer + 1} ---\n")
                for t in range(run.tiles):
                    self.log.insert("end", f"L{layer + 1} run {i:3d} tile {t}:  W=0x{run.weights[t]:08x}  "
                                           f"A=0x{run.activations[t]:08x}  ->  "
                                           f"{int(to_signed32(np.array([res[t]]))[0]):>7d}\n")
                self.log.see("end")
            elif ev[0] == "done":
                self.finish(*ev[1:])
            elif ev[0] == "cpu_log":
                words = self.cpu.fw.image(ev[1][0])
                self.log.insert("end", "PC -> FPGA: hold CPU in reset, write the image:\n")
                for i in range(0, len(words), 4):
                    self.log.insert("end", "    " + "  ".join(f"0x{w:08x}" for w in words[i:i + 4]) + "\n")
                self.log.insert("end", "PC -> FPGA: release the CPU\n"
                                       "CPU: runs layer 1 (128 accelerator runs), ReLU + shift,\n"
                                       "     layer 2 (20 runs), argmax, LEDs, DONE\n")
            elif ev[0] == "cpu_done":
                _, board, expected, pred, us, err = ev
                self.log.insert("end", f"FPGA -> PC: DONE, prediction {pred}, 10 logits\n")
                self.finish_scores(board, expected, pred)
                text = f"CPU on the FPGA ran 148 accelerator runs; JTAG round trip {us / 1000:.0f} ms"
                if err:
                    text += " | CPU MMIO ERROR"
                self.status.config(text=text + f" | LEDs show {pred:04b}")
                self.busy = False
                self.run_btn.config(state="normal")
            elif ev[0] == "error":
                self.status.config(text="Error: " + ev[1][:200])
                self.pred.config(text="!")
                self.busy = False
                self.run_btn.config(state="normal")
        self.root.after(30, self.poll)

    def cpu_worker(self, x_q) -> None:
        try:
            expected = self.model.golden_logits(x_q)[0]
            if "fclk" not in self.session:
                self.events.put(("status", "Programming the FPGA over JTAG (first run only)..."))
            elif not self.session.get("firmware_loaded"):
                self.events.put(("status", "Loading the firmware into the CPU (first CPU run only)..."))
            else:
                self.events.put(("status", "CPU running..."))
            self.events.put(("cpu_log", x_q))
            preds, logits, times, err = self.cpu.classify(x_q)
            self.events.put(("cpu_done", logits[0], expected, int(preds[0]), times[0], err))
        except Exception as exc:  # shown in the window
            self.events.put(("error", str(exc)))

    def finish_scores(self, board, expected, pred: int) -> None:
        self.pred.config(text=str(pred))
        self.scores.insert("end", f"{'digit':>5} {'board':>9} {'expected':>9}\n")
        for d in range(10):
            mark = "  <-" if d == pred else ""
            self.scores.insert("end", f"{d:>5} {int(board[d]):>9} {int(expected[d]):>9}{mark}\n")
        exact = bool(np.array_equal(board, expected))
        self.verdict.config(text="Board matches software exactly" if exact else "MISMATCH",
                            fg="#080" if exact else "#c00")

    def finish(self, board, expected, info) -> None:
        pred = int(np.argmax(board))
        self.finish_scores(board, expected, pred)
        text = f"{len(info.runs)} runs, {info.jobs} dot products ({info.skipped} all-zero chunks skipped)"
        if self.backend == "jtag":
            text += f" | LEDs show {pred:04b}"
        self.status.config(text=text)
        self.busy = False
        self.run_btn.config(state="normal")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--backend", choices=("jtag", "model"), default="jtag")
    ap.add_argument("--bitstream", type=Path, default=REPO / "overlays" / "mini_accel" / "mini_accel.bit")
    args = ap.parse_args()
    root = tk.Tk()
    Demo(root, args.backend, args.bitstream)
    root.mainloop()


if __name__ == "__main__":
    main()
