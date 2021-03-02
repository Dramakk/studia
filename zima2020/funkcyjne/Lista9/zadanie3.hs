import qualified QBF
import qualified NestedQBF

scopeCheck :: (QBF.Var -> Maybe v) -> QBF.Formula -> Maybe (NestedQBF.Formula v)

scopeCheck foo QBF.Bot = pure NestedQBF.Bot
scopeCheck foo (QBF.Not form) =  NestedQBF.Not <$> (scopeCheck foo form)
scopeCheck foo (QBF.And form1 form2) =  (NestedQBF.And <$> (scopeCheck foo form1)) <*> (scopeCheck foo form2)
scopeCheck foo (QBF.Var x) = NestedQBF.Var <$> (foo x)
scopeCheck foo (QBF.All var form) = NestedQBF.All <$> (scopeCheck (\arg -> if arg == var then pure NestedQBF.Z else (NestedQBF.S <$> (foo arg))) form)
