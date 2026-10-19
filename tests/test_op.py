import pytest
import torch

from fse_ops import signed_log1p


def _spec(x: torch.Tensor) -> torch.Tensor:
    """Pure-PyTorch specification line from README."""
    return torch.sign(x) * torch.log1p(x.abs())


def test_output_shape():
    x = torch.randn(3, 4, dtype=torch.float32)
    assert signed_log1p(x).shape == x.shape


def test_output_dtype():
    x = torch.randn(5, dtype=torch.float32)
    assert signed_log1p(x).dtype == torch.float32


def test_exact_numeric_match():
    x = torch.tensor([-2.0, 0.0, 1.0], dtype=torch.float32)
    assert torch.equal(signed_log1p(x), _spec(x))


def test_varied_values_not_noop():
    # Values treated differently: negative, near-zero, positive.
    # Result must differ from the input and across elements.
    x = torch.tensor([-5.0, 0.5, 2.0], dtype=torch.float32)
    y = signed_log1p(x)
    expected = _spec(x)
    assert torch.equal(y, expected)
    assert not torch.equal(y, x)
    assert y[0].item() != y[1].item()
    assert y[1].item() != y[2].item()


def test_rejects_integer_dtype():
    x = torch.tensor([1, 2, 3])
    with pytest.raises(RuntimeError):
        signed_log1p(x)
