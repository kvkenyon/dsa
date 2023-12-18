def binpow(a,b):
  res = 1
  while b > 0:
    if b % 2 == 1:
      res *= a
    a *= a
    b //= 2
  return res

if __name__ == '__main__':
  print(binpow(2,127))