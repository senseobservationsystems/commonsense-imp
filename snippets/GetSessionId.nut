/* GetSessionId
p_credentials: a table containing "username" and "password" key/value pairs

returns: session_id if successful or response status code
*/

function GetSessionId(p_credentials){
    local post_request = http.post("http://api.sense-os.nl/login", {"Content-Type": "application/json"}, http.jsonencode(p_credentials)); // prime a post request object
    
    local post_response = post_request.sendsync(); // send the (synchronised) request and store the response body
    
    return (200 == post_response.statuscode) ? http.jsondecode(post_response.body).session_id : post_response.statuscode;
}

/* Example */

local credentials = {};
credentials.username <- "user";
credentials.password <- "5f4dcc3b5aa765d61d8327deb882cf99";

local session_id = GetSessionId(credentials);

server.log("got session id " + session_id);

