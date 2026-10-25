# fse_ops

Custom PyTorch CPU extension for the FSE4AI final project.

## The operation

**Python name:** `fse_ops.signed_log1p`

**Formula:** for each element `x`, return `sign(x) * log(1 + |x|)`.
In pure PyTorch: `torch.sign(x) * torch.log1p(x.abs())`.

**Accepted input:** CPU `float32` tensors of any shape. A leading batch dimension is treated as extra rows: each element is computed independently of the others.
**Rejected:** non-CPU tensors and non-`float32` dtypes (raises `RuntimeError` from C++ `TORCH_CHECK`).

## Team

See `AUTHORS`. Every member must commit under their listed email.

## Build / install / test

Develop inside the course lab container. From the repository root:

```bash
# CPU torch (once per venv)
python3 -m venv /tmp/build-venv
/tmp/build-venv/bin/pip install torch --index-url https://download.pytorch.org/whl/cpu

# Wheel
/tmp/build-venv/bin/pip wheel . --no-deps -w dist

# Fresh install + pytest against the wheel
python3 -m venv /tmp/try-venv
/tmp/try-venv/bin/pip install torch --index-url https://download.pytorch.org/whl/cpu
/tmp/try-venv/bin/pip install dist/*.whl
/tmp/try-venv/bin/pip install pytest
cp -r tests /tmp/proj-tests
cd /tmp && /tmp/try-venv/bin/python -m pytest -q /tmp/proj-tests
```

Or via Make (inside lab):

```bash
make wheel
make install
make test
make clean
```

Smoke proof:

```bash
./tools/smoke.sh
```

Docker image:

```bash
docker build -t fse-ops:0.1 .
docker run --rm fse-ops:0.1
```

## The project note

Using `python3 -m cProfile -s cumulative`, the workload processed a `float32` tensor with 1,000,000 elements and called `signed_log1p` 100 times. The measured workload time was 1.577 seconds, of which 1.456 seconds accounted for the 100 calls to `fse_ops._C.signed_log1p` (approximately 14.56 ms per call).


**Bug** After `tools/profilee.py` landed on `main`, the CI run failed (GitHub Actions run #8, step `ruff`) with `I001 Import block is un-sorted or un-formatted` in `tools/profilee.py`: the imports were not split into standard-library, third-party and first-party groups. The script itself ran fine; only `ruff check .` was red. Fix: blank lines between the `pstats`, `torch` and `fse_ops` imports, landed in commit `d36de7e`.