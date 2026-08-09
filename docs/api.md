# Sum API

Currently the only supported operation is creating entries. This document itself is served at `GET /api/docs` (no authentication required) so an agent can fetch it directly.

A ready-to-import Postman collection is at `docs/postman_collection.json` (`base_url` and `token` collection variables).

## Authentication

Every endpoint below (except this docs page) requires a Bearer token in the `Authorization` header.

1. Sign in to the web app.
2. Go to **API Tokens** in the nav (`/api_tokens`) and click **New API Token**.
3. Copy the token shown on the next page — it is only ever displayed once. If you lose it, delete it and create a new one.

```
Authorization: Bearer sum_<64 hex characters>
```

Requests without a valid token get `401 Unauthorized`:

```json
{
  "error": "unauthorized",
  "message": "Invalid or missing API token. Send it as `Authorization: Bearer <token>`."
}
```

## POST /api/entries

Creates an entry for the authenticated user. Request body is flat JSON — fields go at the top level, not nested under `"entry"`.

| Field | Type | Required | Notes |
|---|---|---|---|
| `amount` | number | yes | |
| `category_id` | integer | one of `category_id` / `category_name` | must belong to the authenticated user |
| `category_name` | string | one of `category_id` / `category_name` | exact match against one of the user's existing categories; unmatched names are rejected, not auto-created |
| `date` | string (`YYYY-MM-DD`) | no | defaults to today if omitted or blank |
| `notes` | string | no | |
| `tag_name` | string | no | finds an existing tag with this name or creates one |
| `income` | boolean | no | |
| `untracked` | boolean | no | |

### Success — `201 Created`

```json
{
  "entry": {
    "id": 123,
    "date": "2026-08-06",
    "amount": "12.34",
    "notes": "Coffee",
    "income": null,
    "untracked": null,
    "category": { "id": 8, "name": "Groceries" },
    "tag": { "id": 4, "name": "reimbursable" }
  }
}
```

### Errors

`422 Unprocessable Entity` — neither `category_id` nor `category_name` matched, or neither was given. `available_categories` lists the user's valid category names so you can retry:

```json
{
  "error": "category_not_found",
  "message": "No category named \"Grocries\" found for this user.",
  "available_categories": ["Groceries", "Rent", "Salary"]
}
```

`422 Unprocessable Entity` — the entry failed model validation:

```json
{
  "error": "validation_failed",
  "message": "Entry could not be created.",
  "details": ["Date can't be blank"]
}
```

## Example

```bash
curl -X POST https://<your-app-domain>/api/entries \
  -H "Authorization: Bearer sum_xxxxxxxx..." \
  -H "Content-Type: application/json" \
  -d '{"amount": 12.34, "category_name": "Groceries", "notes": "Coffee", "tag_name": "reimbursable"}'
```
