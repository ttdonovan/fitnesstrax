import { encodeFormBody } from './common';

export const authenticate = (authUrl, username, password) => {
    return fetch( authUrl + '/auth'
                , { method: 'PUT'
                  , mode: 'cors'
                  , cache: 'default'
                  , headers: new Headers({'Content-Type': 'application/x-www-form-urlencoded'})
                  , body: encodeFormBody({'username': username, 'password': password})
                  })
                .then((response) => response.ok ? response.json() : {err: response.status})
                .then((res) => res.err ? {err: res.err} : {jwt: res.jwt});
}

