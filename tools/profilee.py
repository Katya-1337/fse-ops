import cProfile
import pstats
import torch
from fse_ops import signed_log1p

x = torch.randn(1_000_000, dtype=torch.float32)


def workload():
    for _ in range(100):
        signed_log1p(x)


if __name__ == "__main__":
    profiler = cProfile.Profile()
    profiler.enable()
    workload()
    profiler.disable()

    stats = pstats.Stats(profiler)
    stats.strip_dirs()
    stats.sort_stats("cumulative")

    print("\n=== TOP 10 FUNCTIONS BY CUMULATIVE TIME ===")
    stats.print_stats(10)

    print("\n=== SIGNED_LOG1P FUNCTION ===")
    stats.print_stats("signed_log1p")
