record Quote {
  quote : String,
  author : String,
  cat : String
}

store QuoteApi {
  fun url : String {
    "https://talaikis.com/api/quotes/random/"
  }

  state quote : Quote = {
    quote = "Hello World",
    author = "Every programmer ever",
    cat = ""
  }

  state status : Quote.Status = Quote.Status::Initial

  fun nextQuote : Promise(Never, Void) {
    sequence {
      next { status = Quote.Status::Loading }

      response =
        Http.get(url())
        |> Http.send()

      body =
        Json.parse(response.body)
        |> Maybe.toResult("Json Parse Error")

      newquote =
        decode body as Quote

      next
        {
          quote = newquote,
          status = Quote.Status::Ok
        }
    } catch {
      next { status = Quote.Status::Error }
    } finally {
      void
    }
  }
}

enum Quote.Status {
  Initial
  Ok
  Loading
  Error
}

component Quote {
  connect QuoteApi exposing { quote }

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
        <{ quote.quote }>
      </p>

      <p::author>
        <{ "~ " + quote.author }>
      </p>
    </div>
  }
}

component RefreshButton {
  connect QuoteApi exposing { nextQuote, status }

  get text : String {
    case (status) {
      Quote.Status::Initial => "Get Quote"
      Quote.Status::Loading => "Loading"
      Quote.Status::Error => "Try Again"
      => "Next Quote"
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
    <a::base onClick={(event : Html.Event) : Promise(Never, Void) => { nextQuote() }}>
      <{ text }>
    </a>
  }
}
