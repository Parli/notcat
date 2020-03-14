import qualified Streaming.Prelude as S
import Streaming.UDP
import Control.Monad.Trans.Resource
import qualified Data.ByteString as B
import System.Environment

main = do
  args <- getArgs
  case args of
    [host, portStr] -> case reads portStr of
      [] -> putStrLn "Invalid port"
      (port, _):_ -> netcat host port
    otherwise -> putStrLn
      "Please specify host and port, e.g.: \n\t./statsd.sh 127.0.0.1 8125"

netcat host port = do
  putStrLn $ "Receiving on "<>host<>":"<>(show port)
  runResourceT $ S.stdoutLn $ S.map txfm udpStream
  where
    udpStream = fromUDP host port len
    txfm = (map (toEnum.fromEnum) . B.unpack) . fst
    len  = 1024
