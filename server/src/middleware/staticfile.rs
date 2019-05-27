extern crate iron;

use self::iron::headers;
use self::iron::middleware::Handler;
use self::iron::mime;
use self::iron::prelude::{IronError, IronResult, Request, Response};
use self::iron::status;
use std::error;
use std::fmt;
use std::fs::File;
use std::io;
use std::io::Read;
use std::path::PathBuf;

#[derive(Debug)]
pub enum Error {
    NotFound(PathBuf),
    IOError { path: PathBuf, err: io::Error },
}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Error::NotFound(path) => write!(f, "File not found: {}", path.to_str().unwrap()),
            Error::IOError { path, err } => write!(
                f,
                "Unhandled IO error: {}, {:?}",
                path.to_str().unwrap(),
                err
            ),
        }
    }
}

impl error::Error for Error {
    fn description(&self) -> &str {
        match self {
            Error::NotFound(_) => "File not found",
            Error::IOError { path: _, err: _ } => "Unhandled IO error",
        }
    }
    fn cause(&self) -> Option<&error::Error> {
        match self {
            Error::NotFound(_) => None,
            Error::IOError { path: _, err } => Some(err),
        }
    }
}

pub enum StaticHandler {
    StaticFile(StaticFile),
}

impl StaticHandler {
    pub fn file(path: PathBuf, content_type: mime::Mime) -> StaticHandler {
        StaticHandler::StaticFile(StaticFile {
            root: path,
            content_type,
        })
    }
}

impl Handler for StaticHandler {
    fn handle(&self, req: &mut Request) -> IronResult<Response> {
        match self {
            StaticHandler::StaticFile(handler) => handler.handle(req),
        }
    }
}

pub struct StaticFile {
    root: PathBuf,
    content_type: mime::Mime,
}

impl Handler for StaticFile {
    fn handle(&self, _: &mut Request) -> IronResult<Response> {
        fn throw_io_error(path: &PathBuf, err: io::Error) -> IronError {
            match err.kind() {
                io::ErrorKind::NotFound => IronError {
                    error: Box::new(Error::NotFound(path.clone())),
                    response: Response::new(),
                },
                _ => IronError {
                    error: Box::new(Error::IOError {
                        path: path.clone(),
                        err,
                    }),
                    response: Response::new(),
                },
            }
        }

        let mut contents = Vec::new();
        let mut file = File::open(&self.root).map_err(|err| throw_io_error(&self.root, err))?;
        file.read_to_end(&mut contents)
            .map_err(|err| throw_io_error(&self.root, err))?;

        let mut h = headers::Headers::new();
        h.set(headers::ContentType(self.content_type.clone()));
        let mut response = Response::with((status::Ok, contents));
        response.headers = h;
        Ok(response)
    }
}
