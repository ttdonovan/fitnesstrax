extern crate iron;
extern crate micrologger;

use self::iron::prelude::{ IronError, IronResult, Request, Response };
use self::iron::middleware::{BeforeMiddleware, AfterMiddleware};
use std::collections::HashMap;

pub struct LoggingMiddleware {
    logger: micrologger::Logger<fn(micrologger::Entry)>,
}

impl LoggingMiddleware {
    pub fn new(host: &str, app: &str) -> LoggingMiddleware {
        LoggingMiddleware{
            logger: micrologger::Logger::new(micrologger::json_stdout, host, app),
        }
    }
}


impl BeforeMiddleware for LoggingMiddleware {
    fn before(&self, req: &mut Request) -> IronResult<()> {
        let mut msg = HashMap::new();
        msg.insert(String::from("request"), json!(format!("{:?}", req)));
        self.logger.log("request", msg);
        Ok(())
    }

    fn catch(&self, _: &mut Request, err: IronError) -> IronResult<()> {
        let mut msg = HashMap::new();
        msg.insert(String::from("request-error"), json!(format!("{:?}", err)));
        self.logger.log("request-error", msg);
        Ok(())
    }
}

impl AfterMiddleware for LoggingMiddleware {
    fn after(&self, _: &mut Request, res: Response) -> IronResult<Response> {
        let mut msg = HashMap::new();
        msg.insert(String::from("response"), json!(format!("{:?}", res)));
        self.logger.log("response", msg);
        Ok(res)
    }

    fn catch(&self, _: &mut Request, err: IronError) -> IronResult<Response> {
        let mut msg = HashMap::new();
        msg.insert(String::from("response-error"), json!(format!("{:?}", err)));
        self.logger.log("response-error", msg);
        Err(err)
    }
}
