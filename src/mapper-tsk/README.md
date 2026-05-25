# Mapper tool 🧰

Mapper tool is a part of the `NodeTskeleton` template project.

`NodeTskeleton` is a `Clean Architecture` based `template project` for `NodeJs` using `TypeScript` to implement with any `web server framework` or even any user interface.

<a href="https://github.com/medevorg/nodetskeleton" target="_blank" >Go to NodeTskeleton</a>
 
## Using Mapper

The `mapper` is a tool that will allow us to change the entities to the `DTOs` within our application, including entity changes between the data model and the domain and vice versa.

## Using Mapper

### Basic mode

This tool maps `objects` or `arrays objects`, for example:

```ts
// Basic mode
import mapper from "mapper-tsk";

// For object
const textFeelingDto = mapper.mapObject<TextFeeling, TextFeelingDto>(
  textFeeling,
  new TextFeelingDto(),
);

// For array objects
const productsDto: ProductDto[] = mapper.mapArray<Product, ProductDto>(
  products,
  () => mapper.activator(ProductDto),
);
```

### Advanced mode

This tool allows you to create custom mapping profiles for direct mapping primitive properties () or even complex objects through static source mapping functions.

Direct property mapping is also allowed for objects but without differences in their property names. (See important note 3)

```ts
// Libraries for use in example

// PersonDto class
import { Country } from "./domain/country";

export class PersonDto {
  Name: string = null;
  LastName: string = null;
  Age: number = null;
  IsActive = false;
  Country: Country = null;
}

// CityDto class
import { City } from "./domain/city";

export class CityDto {
  constructor(public Name: string, public Weather: string) {}

  static mapToCityDomain(city: CityDto): City {
    return new City(city.Name, city.Weather);
  }
}

// CountryDto class
import { Country } from "./domain/country";

export class CountryDto {
  constructor(public Name: string, public City: City) {}
  
  static mapToCountryDomain(country: CountryDto): Country {
    const city = CityDto.mapToCityDomain(country.City);
    return new Country(country.Name, city);
  }
}

// Domain City class
export class City {
  constructor(public name: string, public weather: string) {}
}

// Domain Country class
export class Country {
  constructor(public name: string, public city: City) {}
}

// Person class
export class Person {
  constructor(name: string, lastName: string, age: number, active: boolean) {
    this.name = name;
    this.lastName = lastName;
    this.age = age;
    this.isActive = active;
  }
  name: string;
  lastName: string;
  age: number;
  country: Country;
  isActive: boolean;
}


// Advanced mode
import mapper from "mapper-tsk";

// Mapping profile
const profile = {
  Name: "name",
  LastName: "lastName",
  Age: "age",
  IsActive: "isActive",
  "Country.Name": "country.name",
  "Country.City": {
    destinationKey: "country.city",
    mappingFunction: CityDto.mapToCityDomain,
  },
};

// For object
const person: Person = mapper.mapObject<PersonDto, Person>(
  personDto,
  new Person(),
  profile,
);

// For array objects
const personsDto: PersonDto[] = mapper.mapArray<PersonDto, Person>(
  [personDtoOne, personDtoTwo ...],
  () => mapper.activator(Person),
  profile,
);
```

`Activator` is the function responsible for returning a new instance for each call, otherwise you would have an array with the same object repeated N times. 

## Important notes

- If you are using or plan to use the `DTO pattern`, you `must initialize` the properties of the entities in `NULL`, otherwise the tool will not be able to map the property because it will be `UNDEFINED`, for example:

```ts
export class PersonDto {
  name: string = null;
  lastName: string = null;
  age: number;
}
// In this case, `Age` will be `undefined`, therefore the mapper will not be able to have it in scope.
```

- It is also important to know that `for efficiency` the `mapper links the entity based on the destination`, that is, it goes through the properties of the destination entity and not those of the origin entity.

- It is recommended to use the mapping functions on objects where the names of the properties are different, but if the names are the same in both objects a simple mapping profile like the following example is sufficient.

```ts
// OBSERVATION: for this case the objects have no difference in the names of their properties.

// Only direct mapping profile
const profile = {
  name: "name",
  lastName: "lastName",
  age: "age",
  isActive: "isActive",
  "country.name": "country.name",
  "country.city": "country.city",
};

// or
const profile = {
  name: "name",
  lastName: "lastName",
  age: "age",
  isActive: "isActive",
  country: "country",
};

// The previous mapping profiles will have the same result, but it is obvious that the second one will perform better.

// For object
const person: Person = mapper.mapObject<PersonDto, Person>(
  personDto,
  new Person(),
  profile,
);

// For array objects
const personsDto: PersonDto[] = mapper.mapArray<PersonDto, Person>(
  [personDtoOne, personDtoTwo ...],
  () => mapper.activator(Person),
  profile,
);
```

## RunKit demo

Go to this <a href="https://runkit.com/medevorg/demo-mapper-tsk" target="_blank" >Link</a> or click in `Try on RunKit button` on the right side of the page.

## Warning 💀

> Use this resource at your own risk.
