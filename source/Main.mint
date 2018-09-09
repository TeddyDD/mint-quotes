component Main {
  style base {
    font-family: sans;
    font-weight: bold;
    font-size: 50px;

    justify-content: center;
    align-items: center;
    display: flex;
    flex-direction: column;
    height: 100vh;
    width: 100vw;
  }

  style link {
    padding-top: 2em;
    color: #000;
    font-size: 10px;
  }

  fun render : Html {
    <div::base>
      <Quote/>
      <RefreshButton/>

      <a::link href="https://github.com/TeddyDD/mint-quotes">
        <{ "Get code" }>
      </a>
    </div>
  }
}
