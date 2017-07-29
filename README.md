![Aion](https://user-images.githubusercontent.com/15965147/28745968-d496ca7a-7483-11e7-9b59-659100df5ba8.png)

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
In both cases, run:

```
make clean && make install-hooks
```

To run in a docker container:

```
make && make docker-start
``` 

To run locally:

```
make development && make start-dev
```

In both cases the platform should be accessible at [localhost:4000](localhost:4000)

## Running the tests

To run the tests before pushing to the remote you can simply run:

```
cd aion && mix test
```

## Deployment

TBD

## Built With

* [Phoenix](http://www.phoenixframework.org/) - The web framework used
* [Elm](http://elm-lang.org/) - Used to write frontend

## Contributing

TBD

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
