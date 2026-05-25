# OpenAPI-TSK 🚀

OpenAPI-tsk tool is one part of the `NodeTskeleton` template project to install, to initialize and to interact with it.

`NodeTskeleton` is a `Clean Architecture` based `template project` for `NodeJs` using `TypeScript` to implement with any `web server framework` or even any user interface.

<a href="https://github.com/medevorg/nodetskeleton" target="_blank" >Go to NodeTskeleton</a>


## Using OpenAPI-TSK

The API documentation can already be generated automatically through a strategy in the method where the routes are configured using Open API and also using Zod objects.

You can see the API documentation in NodeTSKeleton project going to the next url once you have setup your local project:
```text
localhost:3003/api/docs
```
But first, you have to setup the project, so if you want, you can do it very fast executing this command on your computer:
- Run it using NPX and replace `my-awesome-project` for your own project name
```console
npx run-tsk setup project-name=my-awesome-project
```

For normal and typical nodejs projects go to **[Normal projects](#nodejs-typical-projects)**

> The API documentation is done in the initializeRoutes method of each controller as shown below:

```ts
  initializeRoutes(router: IRouter): void {
    this.setRouter(router())
    .addRoute({
      method: HttpMethodEnum.POST,
      path: "/v1/users/sign-up",
      handlers: [this.singUp],
      produces: [
        {
          applicationStatus: ApplicationStatus.INVALID_INPUT,
          httpStatus: HttpStatusEnum.BAD_REQUEST,
        },
        {
          applicationStatus: ApplicationStatus.SUCCESS,
          httpStatus: HttpStatusEnum.CREATED,
        },
      ],
    });
  }
```

Then once you have added your route, the same method is used to configure properties called model inside produce and apiDoc, and in this one you can have the following ways to configure your data models (Request, Response, Parameters) through the following Descriptor Objects:

```ts
// To describe a ResultT type (ResultTDescriber and TypeDescriber helps us to do it)
.addRoute({
  method: HttpMethodEnum.POST,
  path: "/v1/users/sign-up",
  handlers: [this.singUp],
  produces: [
    {
      applicationStatus: ApplicationStatus.INVALID_INPUT,
      httpStatus: HttpStatusEnum.BAD_REQUEST,
      model: {
        contentType: HttpContentTypeEnum.APPLICATION_JSON,
        scheme: new ResultDescriber({
          name: Result.name,
          type: PropTypeEnum.OBJECT,
          props: ResultDescriber.defaultError(),
        }),
      },
    },
    {
      applicationStatus: ApplicationStatus.SUCCESS,
      httpStatus: HttpStatusEnum.CREATED,
      model: {
        contentType: HttpContentTypeEnum.APPLICATION_JSON,
        scheme: new ResultTDescriber<TokenDto>({
          name: TokenDto.name,
          type: PropTypeEnum.OBJECT,
          props: {
            data: new TypeDescriber<TokenDto>({
              name: TokenDto.name,
              type: PropTypeEnum.OBJECT,
              // Option one to describe a scheme response type
              props: {
                token: {
                  type: PropTypeEnum.STRING,
                },
                expiresIn: {
                  type: PropTypeEnum.NUMBER,
                },
                { ... }
              },
              // Option two to describe a scheme response type
              props: TypeDescriber.describeProps<TokenDtoType>({
                token: PropTypeEnum.STRING,
                expiresIn: PropTypeEnum.NUMBER,
                owner: TypeDescriber.describeReference<OwnerType>(OwnerDto.name, {
                  email: PropTypeEnum.STRING,
                  sessionId: PropTypeEnum.STRING,
                }),
              }),
            }),
            ...ResultDescriber.default(),
          },
        }),
      },
    },
    {
      applicationStatus: ApplicationStatus.UNAUTHORIZED,
      httpStatus: HttpStatusEnum.UNAUTHORIZED,
      model: {
        contentType: HttpContentTypeEnum.APPLICATION_JSON,
        scheme: new ResultDescriber({
          type: PropTypeEnum.OBJECT,
          props: ResultDescriber.defaultError(),
        }),
      },
    },
  ],
  description: "Self register user",
  apiDoc: {
    requireAuth: false,
    requestBody: {
      description: "User data",
      contentType: HttpContentTypeEnum.APPLICATION_JSON,
      required: true,
      scheme: new TypeDescriber<IUserDto>({
        name: UserDto.name,
        type: PropTypeEnum.OBJECT,
        props: TypeDescriber.describeProps<IUserDto>({
          maskedUid: PropTypeEnum.STRING,
          firstName: PropTypeEnum.STRING,
          lastName: PropTypeEnum.STRING,
          gender: PropTypeEnum.STRING,
          email: PropTypeEnum.STRING,
          passwordB64: PropTypeEnum.STRING,
        }),
      }),
    },
  },
}),

// Observation about ApiDocs TokenDto class for way two to describe a model as example
// Token classes
export type OwnerType = {
  email: string;
  sessionId: string;
};

export class OwnerDto implements OwnerType {
  email: string;
  sessionId: string;

  constructor(props: OwnerType) {
    this.email = props.email;
    this.sessionId = props.sessionId;
  }
}

export type TokenDtoType = {
  token: string;
  expiresIn: number;
  owner: OwnerDto;
};

export class TokenDto implements TokenDtoType {
  token: string;
  expiresIn: number;
  owner: OwnerDto;

  constructor(props: TokenDtoType) {
    this.token = props.token;
    this.expiresIn = props.expiresIn;
    this.owner = props.owner;
  }
}

// To describe a simple Result type (ResultDescriber help us to do it)
produces: [
  {
    applicationStatus: ApplicationStatus.INVALID_INPUT,
    httpStatus: HttpStatusEnum.BAD_REQUEST,
    model: {
      contentType: HttpContentTypeEnum.APPLICATION_JSON,
      scheme: new ResultDescriber({
        type: PropTypeEnum.OBJECT,
        props: ResultDescriber.defaultError(),
      }),
    },
  },
],
apiDoc: {
  requireAuth: false,
},

// To describe any object (TypeDescriber help us to do it)
produces: [
  {
    applicationStatus: ApplicationStatus.SUCCESS,
    httpStatus: HttpStatusEnum.SUCCESS,
    model: {
      contentType: HttpContentTypeEnum.TEXT_PLAIN,
      scheme: new TypeDescriber<string>({
        name: PropTypeEnum.STRING,
        type: PropTypeEnum.PRIMITIVE,
        props: {
          primitive: PropTypeEnum.STRING,
        },
      }),
    },
  },
],
apiDoc: {
  requireAuth: false,
},

// To describe any object using Zod objects
produces: [
  {
    applicationStatus: ApplicationStatus.CREATED,
    httpStatus: HttpStatusEnum.CREATED,
    model: {
      contentType: HttpContentTypeEnum.APPLICATION_JSON,
      scheme: new ResultDescriber<UserDto>({
        name: UserDto.name,
        type: PropTypeEnum.OBJECT,
        props: {
          data: TypeDescriber.describeZodObject(UserDto.name, UserDto.getValidatorToCreate()),
          ...ResultDescriber.default(),
        },
      }),
    },
  },
],
apiDoc: {
  requireAuth: true,
  requestBody: {
    description: "User to create",
    contentType: HttpContentTypeEnum.APPLICATION_JSON,
    required: true,
    scheme: TypeDescriber.describeZodObject(UserDto.name, UserDto.getValidatorToCreate()),
  },
},

// The function getValidatorToCreate from UserDto returns a Zod object validator:
getValidatorToCreate(): ValidatorObj<any> {
  return z.object({
    name: z.string().nonempty(),
    lastName: z.string().nonempty(),
    userName: z.string().optional(),
    email: z.string().email(),
    password: z.string().optional(),
    authId: z.string().optional(),
  });
}


// To describe path or query parameters and security schemes
apiDoc: {
  requireAuth: true,
  securitySchemes: new SecuritySchemesDescriber(
    SecuritySchemesDescriber.HTTP,
    SecuritySchemesDescriber.defaultHttpBearer(),
  ),
  parameters: [
    TypeDescriber.describeUrlParam({
      name: "userId",
      in: ParameterIn.PATH,
      description: "User identifier",
      schema: {
        type: PropTypeEnum.STRING,
      },
    }),
  ],
},
```

To get an overall idea, here an example:

```ts
  initializeRoutes(router: IRouter): void {
    this.setRouter(router());
    this.addRoute({
      method: HttpMethodEnum.POST,
      path: "/v1/auth/login",
      handlers: [this.login],
      produces: [
        {
          applicationStatus: ApplicationStatus.SUCCESS,
          httpStatus: HttpStatusEnum.SUCCESS,
          model: {
            contentType: HttpContentTypeEnum.APPLICATION_JSON,
            scheme: new ResultTDescriber<TokenDto>({
              name: TokenDto.name,
              type: PropTypeEnum.OBJECT,
              props: {
                data: new TypeDescriber<TokenDto>({
                  name: TokenDto.name,
                  type: PropTypeEnum.OBJECT,
                  props: TypeDescriber.describeProps<TokenDto>({
                    token: PropTypeEnum.STRING,
                    expiresIn: PropTypeEnum.NUMBER,
                    // This added section is only a demo to show how to use nested objects in the response
                    owner: TypeDescriber.describeReference<OwnerDto>(OwnerDto.name, {
                      email: PropTypeEnum.STRING,
                      sessionId: PropTypeEnum.STRING,
                    }),
                  }),
                }),
                ...ResultDescriber.default(),
              },
            }),
          },
        },
        {
          applicationStatus: ApplicationStatus.UNAUTHORIZED,
          httpStatus: HttpStatusEnum.UNAUTHORIZED,
          model: {
            contentType: HttpContentTypeEnum.APPLICATION_JSON,
            scheme: new ResultDescriber({
              type: PropTypeEnum.OBJECT,
              props: ResultDescriber.defaultError(),
            }),
          },
        },
      ],
      description: "Login user",
      apiDoc: {
        requireAuth: false,
        requestBody: {
          description: "Credentials for login",
          contentType: HttpContentTypeEnum.APPLICATION_JSON,
          schema: new TypeDescriber<ICredentials>({
            name: "Credentials",
            type: PropTypeEnum.OBJECT,
            props: TypeDescriber.describeProps<ICredentials>({
              email: PropTypeEnum.STRING,
              passwordB64: {
                type: PropTypeEnum.STRING,
                format: PropFormatEnum.BASE64,
              },
            }),
          }),
        },
      },
    });
  }
```

Yes, I know what you're thinking, but no, I thought of that too. 
When you have already registered (described) a model, it is not necessary to describe it again, simply use the `RefTypeDescriber` class and with this the system will simply map internally the reference to the described model if it exists, otherwise, you will have an error in the generated file when it is going to be rendered. 

```ts
  this.addRoute({
    method: HttpMethodEnum.GET,
    path: "/v1/users/:userId",
    handlers: [this.get],
    produces: [
      {
        applicationStatus: ApplicationStatus.SUCCESS,
        httpStatus: HttpStatusEnum.SUCCESS,
        model: {
          contentType: HttpContentTypeEnum.APPLICATION_JSON,
          schema: new RefTypeDescriber({
            type: PropTypeEnum.OBJECT,
            name: Result.name,
          }),
        },
      },
    ],
    description: "Get a user",
    apiDoc: {
      requireAuth: true,
      parameters: [
        TypeDescriber.describeUrlParam({
          name: "userId",
          in: ParameterIn.PATH,
          description: "User identifier",
          scheme: {
            type: PropTypeEnum.STRING,
          },
        }),
      ],
    },
  });
```

Once you run the application in DEV mode then the system will generate the file corresponding to the configuration you injected in the API. 
The file is created in the root of the project with the name `openapi.json` and it would look something like this:

```json
{
  "openapi": "3.0.3",
  "info": {
    "title": "NodeTSkeleton API",
    "version": "1.0.0",
    "description": "Api documentation for NodeTSkeleton project",
    "contact": {
      "name": "TSK Support",
      "url": "https://github.com/medevorg/nodetskeleton",
      "email": "harvic3@protonmail.com"
    },
    "license": {
      "name": "BSD 3-Clause"
    }
  },
  "servers": [
    {
      "url": "http://localhost:3003/api",
      "description": "Local server"
    }
  ],
  "paths": {
    "/v1/auth/logout": {
      "delete": {
        "description": "Logout user",
        "responses": {
          "200": {
            "description": "Success",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ResultTClosedSession"
                }
              }
            }
          },
          "401": {
            "description": "Unauthorized",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Result"
                }
              }
            }
          }
        },
        "security": [
          {
            "http": []
          }
        ]
      }
    },
    "/v1/auth/login": {
      "post": {
        "description": "Login user",
        "responses": {
          "200": {
            "description": "Success",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ResultTTokenDto"
                }
              }
            }
          },
          "401": {
            "description": "Unauthorized",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Result"
                }
              }
            }
          }
        },
        "requestBody": {
          "description": "Credentials for login",
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Credentials"
              }
            }
          }
        }
      }
    },
    "/status": {
      "get": {
        "description": "API status endpoint",
        "responses": {
          "200": {
            "description": "Success",
            "content": {
              "text/plain": {
                "schema": {
                  "type": "string"
                }
              }
            }
          }
        }
      }
    },
    "/v1/users/sign-up": {
      "post": {
        "description": "Self register user",
        "responses": {
          "201": {
            "description": "Created",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/UserDto"
                }
              }
            }
          },
          "400": {
            "description": "Bad Request",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Result"
                }
              }
            }
          },
          "401": {
            "description": "Unauthorized",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Result"
                }
              }
            }
          }
        },
        "requestBody": {
          "description": "User data",
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/UserDto"
              }
            }
          }
        }
      }
    },
    "/v1/users/{userId}": {
      "get": {
        "description": "Get user",
        "responses": {
          "200": {
            "description": "Success",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ResultTUserDto"
                }
              }
            }
          },
          "400": {
            "description": "Bad Request",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Result"
                }
              }
            }
          },
          "401": {
            "description": "Unauthorized",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Result"
                }
              }
            }
          }
        },
        "parameters": [
          {
            "name": "userId",
            "in": "path",
            "description": "User identifier",
            "required": true,
            "allowEmptyValue": false,
            "deprecated": false,
            "schema": {
              "type": "string"
            }
          }
        ]
      }
    }
  },
  "components": {
    "schemas": {
      "Object": {
        "type": "object",
        "properties": {
          "closed": {
            "type": "boolean",
            "nullable": false
          }
        }
      },
      "ResultTClosedSession": {
        "type": "object",
        "properties": {
          "message": {
            "type": "string"
          },
          "statusCode": {
            "type": "string"
          },
          "error": {
            "type": "string"
          },
          "success": {
            "type": "boolean"
          },
          "data": {
            "$ref": "#/components/schemas/Object"
          }
        }
      },
      "Result": {
        "type": "object",
        "properties": {
          "message": {
            "type": "string",
            "nullable": true
          },
          "statusCode": {
            "type": "string"
          },
          "error": {
            "type": "string"
          },
          "success": {
            "type": "boolean"
          }
        }
      },
      "TokenDto": {
        "type": "object",
        "properties": {
          "token": {
            "type": "string",
            "nullable": false
          },
          "expiresIn": {
            "type": "number",
            "nullable": false
          }
        }
      },
      "ResultTTokenDto": {
        "type": "object",
        "properties": {
          "message": {
            "type": "string"
          },
          "statusCode": {
            "type": "string"
          },
          "error": {
            "type": "string"
          },
          "success": {
            "type": "boolean"
          },
          "data": {
            "$ref": "#/components/schemas/TokenDto"
          }
        }
      },
      "Credentials": {
        "type": "object",
        "properties": {
          "email": {
            "type": "string",
            "nullable": false
          },
          "passwordB64": {
            "type": "string",
            "nullable": false,
            "format": "base64"
          }
        }
      },
      "UserDto": {
        "type": "object",
        "properties": {
          "maskedUid": {
            "type": "string",
            "nullable": false
          },
          "firstName": {
            "type": "string",
            "nullable": false
          },
          "lastName": {
            "type": "string",
            "nullable": false
          },
          "email": {
            "type": "string",
            "nullable": false
          },
          "gender": {
            "type": "string",
            "nullable": false
          }
        }
      },
      "ResultTUserDto": {
        "type": "object",
        "properties": {
          "message": {
            "type": "string"
          },
          "statusCode": {
            "type": "string"
          },
          "error": {
            "type": "string"
          },
          "success": {
            "type": "boolean"
          },
          "data": {
            "$ref": "#/components/schemas/UserDto"
          }
        }
      }
    },
    "securitySchemes": {
      "http": {
        "type": "http",
        "description": "Bearer token",
        "scheme": "bearer",
        "bearerFormat": "JWT"
      }
    }
  }
}
```

You can explore and follow the instructions in the official documentation about NodeTSKeleton
<a href="https://github.com/medevorg/nodetskeleton?tab=readme-ov-file#create-your-first-use-case" target="_blank" >Go to NodeTskeleton</a>


## NodeJS Typical projects

To use this tool in common NodeJS projects you can make something like the following strategy:

1. First you will need to add something like the next code into your config file or similar:
```ts
// config/index.ts
export default {
  Environments: {
    Dev: "development",
    // Other environments
  },
  apiDocsInfo: {
    title: "Your-name-project API",
    version: "1.0.0",
    description: "Api documentation for your-name-project",
    contact: {
      name: "TSK Support",
      url: "https://github.com/your-github-username/your-repo-name",
      email: "johndoe@saturno.com",
    },
    license: {
      name: "BSD 3-Clause",
    },
  },
}
```
2. Create a docs folder with the `ApiDocGenerator` class
```ts
// api/docs/index.ts
import { ApiDocGenerator } from "openapi-tsk";
import config from "../../config";

export const apiDocGenerator = new ApiDocGenerator(process.env.ENV ?? config.Environments.Dev, config.apiDocsInfo);
```
3. Use the `ApiDocGenerator` instance class in your controller routes like following:
```ts
// In some controller
// The specs for GET status API route
apiDocGenerator.createRouteDoc({
  method: HttpMethodEnum.GET,
  path: "/status",
  description: "Check if the API is online",
  produces: [
    {
      applicationStatus: "200", httpStatus: HttpStatusEnum.SUCCESS,
      model: {
        contentType: HttpContentTypeEnum.TEXT_PLAIN,
        scheme: new TypeDescriber<string>({
          name: PropTypeEnum.STRING,
          type: PropTypeEnum.PRIMITIVE,
          props: TypeDescriber.describePrimitive(PropTypeEnum.STRING),
        }),
      },
    },
  ],
});
/*
Don't worry about this routing style.
It's because it was using the "oas3-tools", but you can use the typical style for express like: 
app.get("route-path", req, res, next)...
*/
export const statusGET = (req: Request, res: Response, next: NextFunction) => {
  res.status(200).json("Api online at " + new Date().toISOString());
};

// The specs for POST user API route
apiDocGenerator.createRouteDoc({
  method: HttpMethodEnum.POST,
  path: "/v1/users/sign-up",
  description: "Self register user",
  produces: [
    {
      applicationStatus: "200",
      httpStatus: HttpStatusEnum.CREATED,
      model: {
        contentType: HttpContentTypeEnum.APPLICATION_JSON,
        scheme: new TypeDescriber<Omit<IUserDto, "passwordB64">>({
          name: "UserDto",
          type: PropTypeEnum.OBJECT,
          props: TypeDescriber.describeProps<Omit<IUserDto, "passwordB64">>({
            maskedUid: PropTypeEnum.STRING,
            firstName: PropTypeEnum.STRING,
            lastName: PropTypeEnum.STRING,
            gender: PropTypeEnum.STRING,
            email: PropTypeEnum.STRING,
          }),
        }),
      },
    },
    // Add other ones as you need
  ],
  apiDoc: {
    requireAuth: false,
    requestBody: {
      description: "User data",
      contentType: HttpContentTypeEnum.APPLICATION_JSON,
      required: true,
      scheme: new TypeDescriber<IUserDto>({
        name: "User",
        type: PropTypeEnum.OBJECT,
        props: TypeDescriber.describeProps<IUserDto>({
          maskedUid: PropTypeEnum.STRING,
          firstName: PropTypeEnum.STRING,
          lastName: PropTypeEnum.STRING,
          gender: PropTypeEnum.STRING,
          email: PropTypeEnum.STRING,
          passwordB64: PropTypeEnum.STRING,
        }),
      }),
    },
  },
});
export const usersSignUpPOSTV1 = (req: Request, res: Response, next: NextFunction, body: IUserDto) => {
  res.status(200).json(body);
};

// The specs for GET user API route
apiDocGenerator.createRouteDoc({
  method: HttpMethodEnum.GET,
  path: "/v1/users/{maskedUid}",
  description: "Get user by maskedUid",
  produces: [
    {
      applicationStatus: "200",
      httpStatus: HttpStatusEnum.SUCCESS,
      model: {
        contentType: HttpContentTypeEnum.APPLICATION_JSON,
        // The way to get a created or to be created ref
        scheme: new RefTypeDescriber({
          name: "UserDto",
          type: PropTypeEnum.OBJECT,
        }),
      },
    },
    // Add other ones as you need
  ],
  apiDoc: {
    requireAuth: true,
    parameters: [
      TypeDescriber.describeUrlParam({
        name: "maskedUid",
        in: ParameterIn.PATH,
        description: "User maskedUid",
        scheme: {
          type: PropTypeEnum.STRING,
        },
      }),
    ],
  },
});
export const usersEmailGETV1 = (req: Request, res: Response, next: NextFunction, maskedUid: string) => {
  const userMock: IUserDto = {
    maskedUid,
    firstName: "John",
    lastName: "Doe",
    email: "johndoe@saturno.com",
    gender: Gender.MALE,
  };

  res.status(200).json(userMock);
};
```
4. Finally you will have to put the next lines in the file were you are managing your web server application:
```ts
// In index.ts
import { apiDocGenerator } from "./api/docs";

// Setup for your server urls
apiDocGenerator.addServerUrl(`http://localhost:${serverPort}`, "Local server");
apiDocGenerator.addServerUrl("/", "Current server");
apiDocGenerator.saveApiDoc(__dirname, "./openapi.json").finish();
```
5. To conclude, is important to mention you that you would have to use a library for the `OpenAPI Swagger web interface` and setup it according to your framework, for example the library to use with `express` is `swagger-ui-express`.


## Warning 💀

> Use this resource at your own risk.
