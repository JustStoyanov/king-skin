import React, {useState} from 'react';
import './App.css'
import {debugData} from "../utils/debugData";
import {fetchNui} from "../utils/fetchNui";
import {createStyles, Button, Box } from '@mantine/core';


// This will set the NUI to visible if we are
// developing in browser
debugData([
  {
    action: 'setVisible',
    data: true,
  }
])

const useStyles = createStyles((theme) => ({
  box: {
    position: 'absolute',
    backgroundColor: theme.colors.dark[4],
    width: '20rem',
    height: '58.2rem',
    fontFamily: 'initial',
    right: '0'
  },
}));


const menus = {
    'Clothes': [
    'Shirt/Jacket',
    'Jacket',
    'Vest',
    'Arms/Gloves',
    'Pants',
    'Shoes',
    'Decals'
  ],
  
  'Hair': [
    'Beard',
    'Hair'
  ]
}

const App: React.FC = () => {
  const { classes } = useStyles();

  return (
   <Box className={classes.box}>
     {
  Object.keys(menus).map((menu) => (
    <div key={menu}>
      <h2>{menu}</h2>
        {menus[menu].map((item) => (
          <h4 key={item}>{item}</h4>
        ))}
    </div>
  ))
}

   </Box>
  );
}

export default App;