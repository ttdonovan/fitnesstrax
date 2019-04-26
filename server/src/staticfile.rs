extern crate iron;

use self::iron::headers;
use self::iron::middleware::Handler;
use self::iron::mime;
use self::iron::prelude::{IronError, IronResult, Request, Response};
use self::iron::status;
use std::fs::File;
use std::io;
use std::io::Read;
use std::path::PathBuf;

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
        fn throw_io_error(err: io::Error) -> IronError {
            IronError {
                error: Box::new(err),
                response: Response::new(),
            }
        }

        let mut contents = Vec::new();
        let mut file = File::open(&self.root).map_err(throw_io_error)?;
        file.read_to_end(&mut contents).map_err(throw_io_error)?;

        let mut h = headers::Headers::new();
        h.set(headers::ContentType(self.content_type.clone()));
        let mut response = Response::with((status::Ok, contents));
        response.headers = h;
        Ok(response)
    }
}
