#include <string.h>

int facteur(char *u, char *v) {
  size_t n = strlen(u), p = strlen(v);
  if (n > p) return 0;
  for (size_t i = 0; i <= p - n; i++) {
    size_t j = 0;
    while (j < n && u[j] == v[i + j]) j++;
    if (j == n) return 1;
  }
  return 0;
}

#ifdef TEST
#include <assert.h>
int main(void) {
  assert(facteur("", ""));
  assert(facteur("", "abc"));
  assert(!facteur("a", ""));
  assert(facteur("abc", "abc"));
  assert(facteur("bc", "abc"));
  assert(facteur("aab", "aaab"));
  assert(!facteur("abc", "ab"));
  assert(!facteur("ac", "abc"));
  return 0;
}
#endif
