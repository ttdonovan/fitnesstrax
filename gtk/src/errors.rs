use std::error;
use std::fmt;
use std::io;
use std::result;

#[derive(Debug)]
pub enum Error {
    ParseDistanceError,
    ParseDurationError,
    ParseMassError,
    ParseStepsError,
    ParseTimeError,
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
            Error::ParseDistanceError => write!(f, "Failed to parse a distance string"),
            Error::ParseDurationError => write!(f, "Failed to parse a duration string"),
            Error::ParseMassError => write!(f, "Failed to parse a mass string"),
            Error::ParseStepsError => write!(f, "Failed to parse a number of steps"),
            Error::ParseTimeError => write!(f, "Failed to parse a time"),
            Error::TraxError(err) => write!(f, "Trax encountered an error: {}", err),
            Error::IOError(err) => write!(f, "IO Error: {}", err),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::ParseDistanceError => "Failed to parse a distance string",
            Error::ParseDurationError => "Failed to parse a duration string",
            Error::ParseMassError => "Failed to parse a mass string",
            Error::ParseStepsError => "Failed to parse a number of steps",
            Error::ParseTimeError => "Failed to parse a time",
            Error::TraxError(err) => err.description(),
            Error::IOError(err) => err.description(),
        }
    }

    fn cause(&self) -> Option<&(dyn error::Error + 'static)> {
        match self {
            Error::ParseDistanceError => None,
            Error::ParseDurationError => None,
            Error::ParseMassError => None,
            Error::ParseStepsError => None,
            Error::ParseTimeError => None,
            Error::TraxError(ref err) => Some(err),
            Error::IOError(ref err) => Some(err),
        }
    }
}

pub type Result<A> = result::Result<A, Error>;
