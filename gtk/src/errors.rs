use std::error;
use std::fmt;
use std::io;
use std::result;

#[derive(Debug)]
pub enum Error {
    ParseMassError,
    ParseStepsError,
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
            Error::ParseMassError => write!(f, "Failed to parse a mass string"),
            Error::ParseStepsError => write!(f, "Failed to parse a number of steps"),
            Error::TraxError(err) => write!(f, "Trax encountered an error: {}", err),
            Error::IOError(err) => write!(f, "IO Error: {}", err),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::ParseMassError => "Failed to parse a mass string",
            Error::ParseStepsError => "Failed to parse a number of steps",
            Error::TraxError(err) => err.description(),
            Error::IOError(err) => err.description(),
        }
    }

    fn cause(&self) -> Option<&(dyn error::Error + 'static)> {
        match self {
            Error::ParseMassError => None,
            Error::ParseStepsError => None,
            Error::TraxError(ref err) => Some(err),
            Error::IOError(ref err) => Some(err),
        }
    }
}

pub type Result<A> = result::Result<A, Error>;
