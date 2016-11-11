#if os(Linux)
  import Glibc
#else
  import Darwin.C
#endif

func fail(_ message: String? = nil) -> Never {
  if let message = message {
    fputs(message + "\n", stderr)
  }

  exit(1)
}
