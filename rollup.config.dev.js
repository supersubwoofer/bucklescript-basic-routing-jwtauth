import node_resolve from 'rollup-plugin-node-resolve';
import livereload from 'rollup-plugin-livereload';

export default {
  input: './lib/es6/src/main.js', 
  output: {
      name: 'starter',
      file: './dev/main.js',
      format: 'iife'
  },
  plugins: [
      node_resolve({mainFields: ['module', 'main', 'browser']}),
      livereload()
  ]
}
