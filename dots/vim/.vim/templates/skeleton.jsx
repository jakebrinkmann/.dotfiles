import { useState } from 'react'

const Container = ({ children }) => {
  const [count, setCount] = useState(0)

  return (
    <div style={styles.container}>
      <header >
        <p>Hello Vite + React!</p>
        <p>
          <button onClick={() => setCount(count => count + 1)}>
            count is: {count}
          </button>
        </p>
      </header>
      { children }
    </div>
  )
}

const styles = {
  container: {
    margin: '0 auto',
    padding: '50px 100px'
    }
}

export default Container
