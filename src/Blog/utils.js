// Takes a body, if child is block

/* 
  body: [
    {key: "...", _type: "block", children: [{key: "...", ... text: "here is text"}]}
  ]
*/

export const READ_SPEED = 250;

export const articleReadLength = (body) => {
  let count = 0;
  for (let block of body) {
    if (block._type === "block") {
      let children = block.children;
      for (let child of children) {
        const text = child.text.split(" ");
        count += text.length;
      }
    }
  }
  return (count / READ_SPEED).toFixed(1);
};
