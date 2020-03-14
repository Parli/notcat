import qualified Streaming.Prelude as S
import Streaming.UDP
import Control.Monad.Trans.Resource
import Control.Monad.IO.Class
import qualified Data.ByteString as B
import System.Environment
import System.IO

printNow a = putStrLn a >> hFlush stdout

main = do
  args <- getArgs
  case args of
    [host, portStr] -> case reads portStr of
      [] -> printNow "Invalid port"
      (port, _):_ -> netcat host port
    otherwise -> printNow
      "Please specify host and port, e.g.: \n\t./statsd.sh 127.0.0.1 8125"

netcat host port = do
  printNow $ "Receiving on "<>host<>":"<>(show port)
  runResourceT $ S.mapM_ (liftIO . printNow) $ S.map txfm udpStream
  where
    udpStream = fromUDP host port len
    txfm = (map (toEnum.fromEnum) . B.unpack) . fst
    len  = 1024
