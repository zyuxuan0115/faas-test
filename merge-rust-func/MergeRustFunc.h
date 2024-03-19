//===-- HelloWorld.h - Example Transformations ------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_UTILS_MERGERUSTFUNC_H
#define LLVM_TRANSFORMS_UTILS_MERGERUSTFUNC_H

#include "llvm/IR/PassManager.h"

namespace llvm {

class MergeRustFuncPass : public PassInfoMixin<MergeRustFuncPass> {
public:
  PreservedAnalyses run(Module &F, ModuleAnalysisManager &AM);
};

} // namespace llvm

#endif // LLVM_TRANSFORMS_UTILS_HELLOWORLD_H