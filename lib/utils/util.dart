String toEsp(text){
  text = text.replaceAll('Jan', 'Ene');
  text = text.replaceAll('Apr','Abr');
  text = text.replaceAll('Aug','Ago');
  text = text.replaceAll('Dec','Dic');
  return text;
}