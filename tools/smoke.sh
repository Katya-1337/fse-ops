#!/bin/bash
set -euo pipefail

python3 -m venv /tmp/smoke-build &&
/tmp/smoke-build/bin/pip install --upgrade pip &&
/tmp/smoke-build/bin/pip install torch --index-url https://download.pytorch.org/whl/cpu &&
/tmp/smoke-build/bin/pip wheel . --no-deps -w dist &&
ls dist | grep linux &&
python3 -m venv /tmp/smoke-try &&
/tmp/smoke-try/bin/pip install --upgrade pip &&
/tmp/smoke-try/bin/pip install torch --index-url https://download.pytorch.org/whl/cpu &&
/tmp/smoke-try/bin/pip install dist/*.whl &&
cd /tmp &&
/tmp/smoke-try/bin/python -c 'import torch; from fse_ops import signed_log1p; x=torch.tensor([-2., 0., 1.]); y=signed_log1p(x); assert y.shape==x.shape; print(y)' &&
echo OK
