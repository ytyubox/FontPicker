# FontPicker


## Narrative #1
```
A simple page for browsing/selecting google font list.
The page should be able to preview the font.
```

Scenarios (Acceptance criteria)

```
Given the User has connectivity
 When the User requests to see the fonts
 Then the app should display the latest font from remote
  And replace the cache with the new fonts
```

## Narrative #2

```
As an offline User
I want the app to show the latest saved version of the fonts
So I can always enjoy the fonts
```

## Narrative #3

```
Given the user doesn't have connectivity
  And there’s a cached version of the fonts
  And the cache is less than 1 year old
 When the customer requests to see the fonts
 Then the app should display the latest fonts saved

Given the customer doesn't have connectivity
  And there’s a cached version of the fonts
  And the fonts is 1 year old or more
 When the customer requests to see the fonts
 Then the app should display an error message

Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the fonts
 Then the app should display an error message
```

## Use Cases

### Load Fonts From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Fonts List" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates Fonts from valid data.
5. System delivers Fonts.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Font File Data From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Font File Data" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers font file data.

#### Cancel course:
1. System does not deliver font file data nor error.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Font From Cache Use Case

#### Primary course:
1. Execute "Load Fonts List" command with above data.
2. System retrieves font data from cache.
3. System validates cache is less than 1 year old.
4. System creates fonts list from cached data.
5. System delivers fonts list.

#### Retrieval error course (sad path):
1. System delivers error.

#### Expired cache course (sad path): 
1. System delivers no fonts list.

#### Empty cache course (sad path): 
1. System delivers no fonts list.

---

### Load Font File Data From Cache Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Font File Data" command with above data.
2. System retrieves data from the cache.
3. System delivers cached Font File data.

#### Cancel course:
1. System does not deliver Font file data nor error.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers not found error.

---

### Validate Font Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves fonts data from cache.
3. System validates cache is less than 1 year old.

#### Retrieval error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path): 
1. System deletes cache.

---

### Cache Font Use Case

#### Data:
- Font

#### Primary course (happy path):
1. Execute "Save Fonts List" command with above data.
2. System deletes old cache data.
3. System encodes font.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.

---

### Cache Font File Data Use Case

#### Data:
- Font File Data

#### Primary course (happy path):
1. Execute "Save Font File Data" command with above data.
2. System caches font file data.
3. System delivers success message.

#### Saving error course (sad path):
1. System delivers error.

---

## Flowchart

## Model Specs

### Font

| Property      | Type                |
|---------------|---------------------|
| `name`          | `String`              |
| `variants` | `Variant` |
| `subsets`    | `SubSet` |
| `files`            | `[URL]`               |
| `category`            | `String`               |

#### Variant
| Property      | Type                |
|---------------|---------------------|
| `familyName`          | `String`              |
| `variants` | `Variant` |
| `subsets`    | `SubSet` |
| `files`            | `File`               |
| `category`            | `Category`               |

    
### Payload contract

```
GET /webfonts/v1/webfonts?key=YOUR-API-KEY

200 RESPONSE

{
  "kind": "webfonts#webfontList",
  "items": [
    {
      "family": "ABeeZee",
      "variants": [
        "regular",
        "italic"
      ],
      "subsets": [
        "latin",
        ""
      ],
      "version": "v14",
      "lastModified": "2020-09-02",
      "files": {
        "regular": "http://fonts.gstatic.com/s/abeezee/v14/esDR31xSG-6AGleN6tKukbcHCpE.ttf",
        "italic": "http://fonts.gstatic.com/s/abeezee/v14/esDT31xSG-6AGleN2tCklZUCGpG-GQ.ttf"
      },
      "category": "sans-serif",
      "kind": "webfonts#webfont"
    },
    {
      "family": "Abel",
      "variants": [
        "regular"
      ],
      "subsets": [
        "latin"
      ],
      "version": "v12",
      "lastModified": "2020-09-10",
      "files": {
        "regular": "http://fonts.gstatic.com/s/abel/v12/MwQ5bhbm2POE6VhLPJp6qGI.ttf"
      },
      "category": "sans-serif",
      "kind": "webfonts#webfont"
    }
  ]
}
```
