# Resources tool 🧰

Resources tool (Locals) y part of the `NodeTskeleton` template project.

`NodeTskeleton` is a `Clean Architecture` based `template project` for `NodeJs` using `TypeScript` to implement with any `web server framework` or even any user interface.

<a href="https://github.com/medevorg/nodetskeleton" target="_blank" >Go to NodeTskeleton</a>
 
## Using Resources

`Resources` is a basic `internationalization` tool that will allow you to manage and administer the local messages of your application, even with enriched messages, for example:

## Using Resources

The first thing to note is that your resource files must be in json or js format as shown in an example below:

```js
// ./locals/resources/en.local.ts
// Resource file for English.
import { LocalMessageDictionary } from "./keys";

const enMessages: LocalMessageDictionary = {
  SOMETHING_WENT_WRONG: "Oh sorry, something went wrong with current action!",
  SOME_PARAMETERS_ARE_MISSING: "Some parameters are missing: {{missingParams}}.",
  YOUR_OWN_NEED: "You are the user {{name}}, your last name is {{lastName}} and you are {{age}} years old."
  /* others as you needed */
};
export default enMessages;

// ./locals/resources/es.local.ts
// Resource file for Spanish.
import { LocalMessageDictionary } from "./keys";

const esMessages: LocalMessageDictionary = {
  SOMETHING_WENT_WRONG: "Oh lo sentimos, algo salió mal con esta acción!",
  SOME_PARAMETERS_ARE_MISSING: "Faltan algunos parámetros: {{missingParams}}.",
  YOUR_OWN_NEED: "Usted es {{name}}, su apellido es {{lastName}} y su edad es {{age}} años."
  /* others as you needed */
};
export default esMessages;
```

### Important note

The parameters to be replaced in the messages should be in brackets like this, `{{paramName}}`.

As a second step you must have the file that corresponds to the mapping of the keys containing your resource files as shown below:

```js
// ./locals/resources/keys.ts
export enum KeysDictionaryEnum {
  SOMETHING_WENT_WRONG: "SOMETHING_WENT_WRONG",
  SOME_PARAMETERS_ARE_MISSING: "SOME_PARAMETERS_ARE_MISSING",
  YOUR_OWN_NEED: "YOUR_OWN_NEED"
};
// This type name is according to your like
export type LocalMessageDictionary = { [key in keyof typeof KeysDictionaryEnum]: string };
```
So now we can set up our index file which we will use to manage our internationalization resources:

```ts
// ./locals/index.ts
import { KeysDictionaryEnum, LocalMessageDictionary } from "./resources/keys";
import esLocal from "./resources/es.local.ts";
import enLocal from "./resources/en.local.ts";
import { Resources } from "resources-tsk";

export enum LocaleTypeEnum {
  ES = "es_ES",
  EN = "en_US",
}

type LocaleType = {
  [K in LocaleTypeEnum]: LocalMessageDictionary;
};

const locals: LocaleType = {
  [LocaleTypeEnum.ES]: esLocal,
  [LocaleTypeEnum.EN]: enLocal,
};

const defaultLanguage = LocaleTypeEnum.ES;
// The types are for strict control to improve inference and avoid errors
const resources = new Resources<LocaleTypeEnum, KeysDictionaryEnum, LocalMessageDictionary, LocaleType>(locals, KeysDictionaryEnum, defaultLanguage);

export default resources;
```

Okay, so now you can use your resources where you need them, an example would be this:

```ts
import resources from "../locals/index";

const simpleMessage = resources.get(resources.keys.ITEM_PRODUCT_DOES_NOT_EXIST);

const enrichedMessage = resources.getWithParams(resources.keys.SOME_PARAMETERS_ARE_MISSING, {
	missingParams: keysNotFound.join(", "),
});

// You can add enriched messages according to your own needs, for example:
const yourEnrichedMessage = resources.getWithParams(resources.keys.YOUR_OWN_NEED, {
	name: firstName, lastName, age: userAge
});
/*
	Output:
	You are the user John, your last name is Doe and you are 24 yeard old.
*/
```
And you can add all the parameters you need with as many messages in your application as required.

> The resource files can be local or you can get them from an external service.

## Important

> Don't forget to perform the language initialization for your resource manager in the localization middleware as following:

```ts
import resources from "../locals/index";

// add this line into your localization function considering the web framework you're using
resources.init(req.headers["accept-language"] || defaultLang);
```
But if you prefer, applying the concept of `pure function`, you have the option to pass the `optional language parameter` in the functions to get the parameters as shown below:

```ts
const message = resources.get(localKeys.SOMETHING_WENT_WRONG, user.language);
// Or
const enrichedMessage = resources.getWithParams(
	resources.keys.NOT_VALID_EMAIL,
	{ email: user.email },
	user.language,
);
```

## Replace function

> The library provides a static function to replace keys into text as follow:

```ts
import { Resources } from "resources-tsk";

const text = "This is a text with {{name}} and {{lastName}}.";
const params = { 
	name: "Carl",
	lastName: "Sagan",
};

const textReady = Resources.replaceParams(text, params);
console.log(textReady);
// This is a text with Carl and Sagan.
```

## RunKit demo

Go to this <a href="https://runkit.com/medevorg/demo-resources-tsk" target="_blank" >Link</a> or click in `Try on RunKit button` on the right side of the page.

## Warning 💀

> Use this resource at your own risk.
