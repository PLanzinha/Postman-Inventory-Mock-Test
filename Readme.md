# Project 6: Postman Inventory Mock Test

My main goal for this project was to better learn how to create and use Postman's built-in Mock Server feature.

**Goals:**
*   To create a new Mock Server directly within Postman.
*   To define several "Examples"—specific request/response pairs—for different endpoints and HTTP methods on the mock server. This included setting expected response codes, headers, and bodies.
*   To write a separate Postman collection that sends requests *to this mock server*.
*   To write tests that validate whether the mock server returns the predefined responses correctly, based on matching the example for the incoming request.
*   To understand how to use the mock server's unique URL with environment variables.
*   To explore how mock servers can provide dynamic responses by reflecting parts of the request, like `{{request.body.field}}`, in the example response.
*   To set up a Jenkins CI/CD pipeline to automate tests against this mock server.

**API I Used:**
*   A custom "Product Inventory" mock API that I defined. This API is hosted by Postman's Mock Server infrastructure. The URL for this mock was stored in the `mockBaseUrl` variable within the `Mock Server Env (Project 6)`.

**Results:**
*   I successfully created a multi-endpoint mock server. It had various examples covering success cases like GET all, GET specific, POST create, and an error case like GET non-existent product returning 404.
*   I developed a test collection that validated the behavior of this mock server. All tests passed, confirming the mock server correctly served the defined examples.
*   I also successfully integrated the execution of these mock server tests into a Jenkins CI/CD pipeline.

**Problems Faced:**
*   Initially, my tests failed with `400 Bad Request` errors when running against the mock server in Jenkins.
*   **Resolution:** This was traced back to the `mockBaseUrl` environment variable. I had to ensure the environment file used by Newman/Jenkins contained the *correct, unique URL* for the mock server I had created in Postman, not a placeholder or an old URL.
*   Another learning point was to double-check if the mock server was set to "private." If it were, I would have needed to ensure an `x-api-key` header with my Postman API key was sent. For this project, I kept the mock public to simplify testing.
*   Understanding the matching logic, primarily method and path, for examples was key to the mock server returning the intended response.

### Test Cases for Project 6

**Test Suite:** P6 - Postman Inventory Mock Test

| ID | Title | Preconditions | Steps | Expected Results |
| :- | :- | :- | :- | :- |
| **P6-001** | Retrieve all products from the mock server | - Postman Mock Server is active; its URL is in `mockBaseUrl`.<br>- An example exists for `GET /products`. | 1. Send `GET` to `{{mockBaseUrl}}/products`. | 1. Status is `200 OK`.<br>2. Response is a JSON array.<br>3. Each object in the array has `id`, `name`, `category`, `price`, `inStock`. |
| **P6-002** | Retrieve a specific, existing product | - Mock server is active.<br>- An example exists for `GET /products/prod_123`. | 1. Send `GET` to `{{mockBaseUrl}}/products/prod_123`. | 1. Status is `200 OK`.<br>2. Response is a JSON object.<br>3. `id` in the response is `prod_123`, and other fields match the defined example. |
| **P6-003** | Attempt to retrieve a non-existent product | - Mock server is active.<br>- An example exists for `GET /products/prod_999` with a 404 response. | 1. Send `GET` to `{{mockBaseUrl}}/products/prod_999`. | 1. Status is `404 Not Found`.<br>2. Response contains the error message and `productId` as defined in the 404 example. |
| **P6-004** | Create a new product (mocked response) | - Mock server is active.<br>- An example exists for `POST /products`. | 1. Send `POST` to `{{mockBaseUrl}}/products` with a valid JSON body for a new product. | 1. Status is `201 Created`.<br>2. Response contains the `id` and `message` as defined in the static mock example. |