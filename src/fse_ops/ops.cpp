#include <torch/extension.h>

torch::Tensor signed_log1p(torch::Tensor input) {
    TORCH_CHECK(input.device().is_cpu(), "signed_log1p is CPU only");
    TORCH_CHECK(
        input.scalar_type() == torch::kFloat32,
        "signed_log1p expects float32 tensors");
    return input.sign() * input.abs().log1p();
}

PYBIND11_MODULE(TORCH_EXTENSION_NAME, module) {
    module.def(
        "signed_log1p",
        &signed_log1p,
        "Signed log1p: sign(x) * log1p(|x|) on CPU float32");
}
