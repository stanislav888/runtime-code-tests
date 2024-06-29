#pragma once

#ifndef __has_feature
// GCC does not have __has_feature...
#define __has_feature(feature) 0
#endif

#if __has_feature(address_sanitizer) || defined(__SANITIZE_ADDRESS__)
#ifdef __cplusplus
extern "C"
#endif
const char *__asan_default_options() {
  return "fast_unwind_on_malloc=0:detect_stack_use_after_return=true:fast_unwind_on_malloc=0";
}
#endif