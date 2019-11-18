# -*- coding: utf-8 -*-


class Formula:
  def __init__(self, left, right):
    self.left = left
    self.right = right

  def __str__(self):
    raise NotImplementedError

  def oblicz(self, zmienne):
    raise NotImplementedError

  def is_tautology(self, vars):
    def permutations(i, vars):
      ans = {}
      for var in vars:
        if i % 2 == 0:
          ans[var] = False
        else:
          ans[var] = True
        i >>= 1
      return ans

    how_many_vars = len(vars)
    for i in range((1 << how_many_vars)):
      sigma = permutations(i, vars)
      if not self.oblicz(sigma):
        return False

    return True


class Impl(Formula):
  def __init__(self, left, right):
    super().__init__(left, right)

  def __str__(self):
    return f'({self.left} ⇒ {self.right})'

  def oblicz(self, vars):
    return not (self.left.oblicz(vars)) or self.right.oblicz(vars)


class And(Formula):
  def __init__(self, left, right):
    super().__init__(left, right)

  def __str__(self):
    return f'({self.left} ∧ {self.right})'

  def oblicz(self, vars):
    return self.left.oblicz(vars) and self.right.oblicz(vars)


class Or(Formula):
  def __init__(self, left, right):
    super().__init__(left, right)

  def __str__(self):
    return f'({self.left} ∨ {self.right})'

  def oblicz(self, vars):
    return self.left.oblicz(vars) or self.right.oblicz(vars)


class Neg(Formula):
  def __init__(self, expr):
    self.expr = expr

  def __str__(self):
    return f'(¬({self.expr}))'

  def oblicz(self, vars):
    return not (self.expr.oblicz(vars))


class Eq(Formula):
  def __int__(self, left, right):
    super().__init__(left, right)

  def __str__(self):
    return f'({self.left} <=> {self.right})'

  def oblicz(self, vars):
    return self.left.oblicz(vars) == self.right.oblicz(vars)


class _True(Formula):
  def __str__(self):
    return 'true'

  def oblicz(self, vars):
    return True


class _False(Formula):
  def __str__(self):
    return 'false'

  def oblicz(self, vars):
    return False


class Zmienna(Formula):
  def __init__(self, var):
    self.var = var

  def __str__(self):
    return self.var

  def oblicz(self, vars):
    if self.var not in vars:
      print(f'Zmienna {self.var} nie jest przypisana')
    else:
      return vars[self.var]


if __name__ == "__main__":
    x, y, z = Zmienna('x'), Zmienna('y'), Zmienna('z')
    p = Or(x, y)
    q = And(z, p)

    env = {
        'x' : True,
        'y' : False,
        'z' : True
    }
    print(And(Zmienna('x'), Or(Neg(Zmienna('x')), Zmienna('x'))))

    print(q, q.oblicz(env))

    p = Eq(Zmienna("x"), Zmienna("x"))
    print(p, p.oblicz(env))
    print(p, "tautologia: ", p.is_tautology(env))

    p = Impl(Or(And(Zmienna("x"), Zmienna("y")), Zmienna("x")), Neg(Zmienna("x")))
    print(p, 'tautologia: ', p.is_tautology(env))

    p = Impl(Zmienna("x"), Or(Zmienna("x"), Zmienna("y")))
    print(p, 'tautologia: ', p.is_tautology(env))


