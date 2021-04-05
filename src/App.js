import logo from "./logo.svg";
import "./App.css";
import Elm from "react-elm-components";
import StartPage from "./ElmMain.elm";

function App() {
  return (
    <div className="App">
      <Elm src={StartPage.Elm.ElmMain} />
    </div>
  );
}

export default App;
