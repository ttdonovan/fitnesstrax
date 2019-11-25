use std::error;
use std::fmt;
use std::io;
use std::result;

#[derive(Debug)]
pub enum Error {
    TraxError(fitnesstrax::Error),
    IOError(io::Error),
}

impl From<fitnesstrax::Error> for Error {
    fn from(error: fitnesstrax::Error) -> Self {
        Error::TraxError(error)
    }
}

impl From<io::Error> for Error {
    fn from(error: io::Error) -> Self {
        Error::IOError(error)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::TraxError(err) => write!(f, "Trax encountered an error: {}", err),
            Error::IOError(err) => write!(f, "IO Error: {}", err),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::TraxError(err) => err.description(),
            Error::IOError(err) => err.description(),
        }
    }

    fn cause(&self) -> Option<&(dyn error::Error + 'static)> {
        match self {
            Error::TraxError(ref err) => Some(err),
            Error::IOError(ref err) => Some(err),
        }
    }
}

pub type Result<A> = result::Result<A, Error>;
