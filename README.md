# Jotason

A lightweight language that adds syntactic sugar to JSON.

## What is Jotason?

Why would we write this JSON:

```
{
    "_id": 1237,
    "name": "Walter Merriam",
    "birthdate": "08/23/1987",
    "allergic": false,
    "celiac": false,
    "diabetic": false,
    "hypertensive": false,
    "diseases": ["Urinary Tract Infection"],
    "medications": [
        {
            "name": "Amoxicilin",
            "dosage": "500mg/8h"
        },
        {
            "name": "Aspirin",
            "dosage": "3g/1d"
        },
        {
            "name": "Ibuprofen",
            "dosage": "200mg/6h"
        }
    ]
}
```

when we can write this Jotason:

```
{
    _id: 1237,
    name: "Walter Merriam",
    birthdate: "08/23/1987",
    allergic, celiac, diabetic, hypertensive: false,
    diseases: ["Urinary Tract Infection"],
    medications": [
        (name, dosage):
        "Amoxicillin", "500mg/8h",
        "Aspirin", "3g/1d",
        "Ibuprofen", "200mg/6h"
    ]
}
```

## Credits

Credit to [@LeonardoVal](https://github.com/LeonardoVal) for the original JS-Data idea.

