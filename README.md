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
