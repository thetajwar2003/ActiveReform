import "semantic-ui-css/semantic.min.css";
import Navbar from "../components/Navbar";
import { UserContext } from "../lib/context";
import { useUserData } from "../lib/hooks";

function MyApp({ Component, pageProps }) {
  const userData = useUserData();
  return (
    // hard coded - will change
    <UserContext.Provider value={userData}>
      <Navbar />
      <Component {...pageProps} />
    </UserContext.Provider>
  );
}

export default MyApp;
