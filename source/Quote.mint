record Joke {
  id : String,
  joke : String,
  status : Number
}

store JokeApi {
  get url : String {
    "https://icanhazdadjoke.com/"
  }

  get agent : String {
    "Mint Qutoes example (https://github.com/TeddyDD/mint-jokes)"
  }

  state joke : Joke = {
    id = "",
    joke = "I'm not even sorry",
    status = 0
  }

  state status : Joke.Status = Joke.Status::Initial

  fun nextJoke : Promise(Never, Void) {
    sequence {
      next { status = Joke.Status::Loading }

      response =
        Http.get(url)
        |> Http.header("Accept", "application/json")
        |> Http.send()

      body =
        Json.parse(response.body)
        |> Maybe.toResult("Json Parse Error")

      newjoke =
        decode body as Joke

      next
        {
          joke = newjoke,
          status = Joke.Status::Ok
        }
    } catch {
      next { status = Joke.Status::Error }
    } finally {
      void
    }
  }
}

enum Joke.Status {
  Initial
  Ok
  Loading
  Error
}

component Joke {
  connect JokeApi exposing { joke }

  style base {
    font-size: 25pt;
    max-width: 80vh;
  }

  style author {
    font-size: 15pt;
    padding-bottom: 2em;
    color: #666;
  }

  fun render : Html {
    <div::base>
      <p>
        <{ joke.joke }>
      </p>

      <p::author>
        <{ "id: " + joke.id }>
      </p>
    </div>
  }
}

component RefreshButton {
  connect JokeApi exposing { nextJoke, status }

  get text : String {
    case (status) {
      Joke.Status::Initial => "Get Joke"
      Joke.Status::Loading => "Loading"
      Joke.Status::Error => "Try Again"
      => "Next Joke"
    }
  }

  style base {
    font-size: 20pt;
    background-color: #000;
    color: #FFF;
    padding: 0.4em;

    &:hover {
      background-color: #FFF;
      color: #000;
      outline: 3px solid;
    }
  }

  fun render : Html {
    <a::base onClick={(event : Html.Event) : Promise(Never, Void) { nextJoke() }}>
      <{ text }>
    </a>
  }
}
