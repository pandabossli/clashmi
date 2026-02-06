# Microsoft Store / MSIX official docs research log

## Attempted sources (blocked in this environment)

The environment blocked outbound HTTPS requests to `learn.microsoft.com` with a 403 on CONNECT.

- `curl -L "https://learn.microsoft.com/en-us/windows/msix/overview"`
  - Result: `curl: (56) CONNECT tunnel failed, response 403`
- `curl -L "https://learn.microsoft.com/en-us/windows/msix/"`
  - Result: `curl: (56) CONNECT tunnel failed, response 403`

## Impact

Unable to retrieve or quote official Microsoft documentation from this environment.
