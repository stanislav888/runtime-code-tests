void library(char *s) {
  const char *cs = "string";
  while (*cs)
    *s++ = *cs++;
  *s = 0;
}