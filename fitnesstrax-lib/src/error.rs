use std::error;
use std::fmt;
use std::result;

#[derive(Debug)]
pub enum Error {
    InvalidParameter,
    NoSeries,
    SeriesError(emseries::Error),
}

impl From<emseries::Error> for Error {
    fn from(error: emseries::Error) -> Self {
        Error::SeriesError(error)
    }
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::InvalidParameter => write!(f, "Invalid parameter"),
            Error::NoSeries => write!(f, "Series is not open"),
            Error::SeriesError(err) => write!(f, "Series Error: {}", err),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::InvalidParameter => "Invalid parameter",
            Error::NoSeries => "Series is not open",
            Error::SeriesError(err) => err.description(),
        }
    }

    fn cause(&self) -> Option<&error::Error> {
        match self {
            Error::InvalidParameter => None,
            Error::NoSeries => None,
            Error::SeriesError(ref err) => Some(err),
        }
    }
}

pub type Result<A> = result::Result<A, Error>;
