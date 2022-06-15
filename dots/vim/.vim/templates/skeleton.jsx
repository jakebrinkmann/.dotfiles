import React, { useState, useCallback } from 'react'

const Container = ({ children }) => {
  const [count, setCount] = useState(0)
  const handleCountChange = useCallback((event) => {
    // setUsername(event.target.value)
    setCount(count + 1)
  }, [])

  return (
    <div style={styles.container}>
      <header >
        <p>Hello World!</p>
        <p>
          <button onClick={handleCountChange}>
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
