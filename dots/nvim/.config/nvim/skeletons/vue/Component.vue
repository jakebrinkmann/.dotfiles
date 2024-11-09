<template>
  <div class="my-component">
    <h1>{{ title }}</h1>
    <button @click="changeTitle">Change Title</button>
  </div>
</template>

<script>
export default {
  name: "MyComponent", // The name of the component
  data() {
    return {
      title: "Hello, Vue!", // Component's reactive data
    };
  },
  methods: {
    changeTitle() {
      this.title = "Title has been changed!"; // Change the title when the button is clicked
    },
  },
  computed: {
    // Any computed properties go here
  },
  watch: {
    // Watching for changes in data
  },
  created() {
    // Lifecycle hook when the component is created
    console.log("MyComponent created!");
  },
  mounted() {
    // Lifecycle hook when the component is mounted to the DOM
    console.log("MyComponent mounted!");
  },
};
</script>

<style scoped>
.my-component {
  text-align: center;
  font-family: Arial, sans-serif;
}

button {
  background-color: #42b983;
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  font-size: 16px;
}

button:hover {
  background-color: #35495e;
}
</style>
