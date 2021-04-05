import "./App.css";
import Elm from "react-elm-components";
import StartPage from "./ElmMain.elm";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import Blog from "./Blog/List.elm";
import Post from "./Blog/Post";

function App() {
  return (
    <Router>
      <Switch>
        <Route path="/blog/:slug">
          <Post />
        </Route>
        <Route path="/blog">
          <Elm src={Blog.Elm.Blog.List} />
        </Route>
        <Route path="/">
          <Elm src={StartPage.Elm.ElmMain} />
        </Route>
      </Switch>
    </Router>
  );
}

export default App;
