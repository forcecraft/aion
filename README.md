![Aion](https://user-images.githubusercontent.com/15965147/28745968-d496ca7a-7483-11e7-9b59-659100df5ba8.png)


# Aion [![Build Status](https://travis-ci.org/forcecraft/aion.svg?branch=master)](https://travis-ci.org/forcecraft/aion) [![codebeat badge](https://codebeat.co/badges/6295caf3-edc7-4eba-926a-cfdb51dbe1eb)](https://codebeat.co/projects/github-com-forcecraft-aion-master)

An e-learning platform written in Elixir and Elm based on real-time gameplay.

### Prerequisites

If you want to run the project in a docker container you need to install:
- docker
- docker-compose

If you want to run it locally:
- elixir
- npm
- postgres
- python3 (only if you want to seed the database with prepared data)

### Installing

You can run the project both in a docker container or locally.

To run in a docker container:

```
make docker-build && make docker-start
```

To run locally:

```
make development
```

In both cases the platform should be accessible at [localhost:4000](localhost:4000)

## Running the tests

To run the tests before pushing to the remote you can simply run:

```
make test
```


## Built With

* [Phoenix](http://www.phoenixframework.org/) - The web framework used
* [Elm](http://elm-lang.org/) - Used to write frontend

## Contributing

Check out our [CONTRIBUTING.md](CONTRIBUTING.md)

## Authors

* **[Piotr Jatkowski](http://github.com/jtkpiotr)**
* **[Patryk Mrukot](http://github.com/pmrukot)**
* **[Maciej Rapacz](http://github.com/mrapacz)**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Initial database was provided by 5th August Witkowski High School in Kraków. One of the main goals of the project was
to rebuild *JPKS*, a simple system with similar functionality, which was once a source of entertainment and knowledge
for many High School students.
