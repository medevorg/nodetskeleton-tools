# Validator tool 🧰

Validator tool y part of the `NodeTskeleton` template project.

`NodeTskeleton` is a `Clean Architecture` based `template project` for `NodeJs` using `TypeScript` to implement with any `web server framework` or even any user interface.

<a href="https://github.com/medevorg/nodetskeleton" target="_blank" >Go to NodeTskeleton</a>
 
## Using Validator

`Validator` is a `very basic` but `dynamic tool` and with it you will be able to `validate any type of object and/or parameters` that your use case `requires as input`, and with it you will be able to `return enriched messages` to the `client` regarding the `errors` or necessary parameters not identified in the `input requirements`, for example:

```ts
import { Validator } from "validator-tsk";
import resources from "../../locals/index";

const resourceKey = "SOME_PARAMETERS_ARE_MISSING";
/*
 english local key for validator:
 "SOME_PARAMETERS_ARE_MISSING": "Some parameters are missing or not valid: {{missingParams}}.",
 Note: You can change the message, but not the key `{{missingParams}}` 
*/

const validator = new Validator(resources, resourceKey);

/*...*/
async execute(userUid: string, itemDto: CarItemDto): Promise<IResult<CarItemDto>> {
	const result = new Result<CarItemDto>();
	if (
		!validator.isValidEntry(result, {
			User_Identifier: userUid,
			Car_Item: itemDto,
			Order_Id: itemDto?.orderId,
			Product_Detail_Id: itemDto?.productDetailId,
			Quantity: itemDto?.quantity,
		})
	) {
		/* 
		The error message on the result object will include a base message and will add to 
		it all the parameter names that were passed on the object that do not have a valid value.
		*/
		return result;
	}
	/*...*/
	return result;
}
/*...*/
```

Suppose that in the above example the itemDto object has no `orderId` and no `quantity`, then the `result of the error` in the `object result` based on the message of the `SOME_PARAMETERS_ARE_MISSING` for `english local file` would be something like this:

`Some parameters are missing or not valid: Order_Id, Quantity.`

### Important note

In the `validation process` the result of messages obtained will be inserted in the `{{missingParams}}` key of the local message.
> You can change the message, but not the key `{{missingParams}}`.

### Validations functions (New Feature 🤩)

The `validation functions` extend the `isValidEntry` method to inject `small functions` created for `your own needs`.

The philosophy of this tool is that `it adapts to your own needs` and not that you adapt to it.

To do this the `isValidEntry function` input value key pair also accepts `array of small functions` that must perform a specific task with the parameter to be validated.

### Observation

If you are going to use the `validation functions` feature, you must send as a parameter an array `even if it is only a function`.

### Important note

The validation function should return `NULL` if the parameter for validate `is valid` and a `string message` indicating the reason why the parameter `is not valid`.

```ts
// Validator functions created to meet your own needs
function validateEmail(email: string): string {
  if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
    return null;
  }
  return resources.getWithParams(resources.keys.NOT_VALID_EMAIL, { email });
}

function greaterThan(numberName: string, base: number, evaluate: number): string {
  if (evaluate && evaluate > base) {
    return null;
  }
  return resources.getWithParams(resources.keys.NUMBER_GREATER_THAN, {
    name: numberName,
    baseNumber: base.toString(),
  });
}

function evenNumber(numberName: string, evaluate: number): string {
  if (evaluate && evaluate % 2 === 0) {
    return null;
  }
  return resources.getWithParams(resources.keys.MUST_BE_EVEN_NUMBER, {
    numberName,
  });
}

// Input in any use case
const person = new Person("John", "Doe", 21, "myemail@orion.com");
/*...*/
const result = new Result();
if(!validator.isValidEntry(result, {
	Name: person.name,
	Last_Name: person.lastName,
	Age: [
		() => greaterThan("Age", 25, person.age),
		() => evenNumber("Age", person.age),
	],
	Email: [() => validateEmail(person.email)],
})) {
	return result;
}
/* 
	result.error would have the following message
	"Some parameters are missing or not valid: The number Age must be greater than 25, The Age param should be even."
*/
```

## Object arrays validation (Basic way)

The utility `only receives array of functions`, so you cannot send object arrays to validate because it does not make sense to do that since the utility will not have a clear context of what to validate in that condition.

The most correct would be to perform basic validations such as the number of objects as shown in the following example or to build functions that validate more particular aspects according to the needs of each case and send these functions as validation arrays.

```ts
const people = [personOne, personTwo, ..., personN];
const isValid = validator.isValidEntry(result, {
  People: [() => people.length >= 1],
});
console.log(isValid);
// true

const people = [personOne, personTwo];
const isValid = validator.isValidEntry(result, {
  People: [() => people.length >= 3],
});
console.log(isValid);
// false
console.log(result.error);
// Some parameters are missing or not valid: People.
```
If you send array objects you will receive a `Throw Error as result`.

## Params for constructor

- resources: you need to install and initialize `npm i resources-tsk`.
- resourceKey: resource message to search the local archive collection.
- defaultErrorCode: code error for result, by default is 400 (BAD_REQUEST), `it's optional`.

## RunKit demo

Go to this <a href="https://runkit.com/medevorg/demo-validator-tsk" target="_blank" >Link</a> or click in `Try on RunKit button` on the right side of the page.

## Warning 💀

> Use this resource at your own risk.
