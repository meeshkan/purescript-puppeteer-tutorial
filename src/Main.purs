module Main where

import Prelude
import Control.Promise (Promise, toAff, toAffE)
import Effect (Effect)
import Effect.Aff (Aff, bracket, launchAff_)
import Effect.Class (liftEffect)
import Foreign (Foreign)

class Affable a b | a -> b where
  asAff :: a -> b

instance promiseAffable :: Affable (Promise a) (Aff a) where
  asAff = toAff

instance effectPromiseAffable :: Affable (Effect (Promise a)) (Aff a) where
  asAff = toAffE

instance fnAffable :: Affable b c => Affable (Function a b) (Function a c) where
  asAff = (<<<) asAff

type Affize a
  = forall b. Affable a b => b

foreign import data LambdaCallback :: Type

foreign import data Browser :: Type

foreign import data Page :: Type

type EPromise a
  = Effect (Promise a)

foreign import executablePath_ :: EPromise String

executablePath = asAff executablePath_ :: Aff String

type LaunchBrowser_
  = String -> EPromise Browser

foreign import launchBrowser_ :: LaunchBrowser_

launchBrowser = asAff launchBrowser_ :: Affize LaunchBrowser_

type NewPage_
  = Browser -> EPromise Page

foreign import newPage_ :: NewPage_

newPage = asAff newPage_ :: Affize NewPage_

type Goto_
  = Page -> String -> EPromise Unit

foreign import goto_ :: Goto_

goto = asAff goto_ :: Affize Goto_

type Screenshot_
  = Page -> String -> EPromise Unit

foreign import screenshot_ :: Screenshot_

screenshot = asAff screenshot_ :: Affize Screenshot_

type Title_
  = Page -> EPromise String

foreign import title_ :: Title_

title = asAff title_ :: Affize Title_

type Close_
  = Browser -> EPromise Unit

foreign import close_ :: Close_

close = asAff close_ :: Affize Close_

foreign import resolveCallback :: LambdaCallback -> String -> Effect Unit

handler ::
  Foreign ->
  Foreign ->
  LambdaCallback ->
  Effect Unit
handler event context callback =
  launchAff_
    $ bracket
        (executablePath >>= launchBrowser)
        close
        ( \browser -> do
            page <- newPage browser
            goto page "https://example.com"
            screenshot page "/tmp/foo.png"
            title page
        )
    >>= liftEffect
    <<< resolveCallback callback
