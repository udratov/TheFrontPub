<script>
  
  import StatusModalContent from "./StatusModalContent.svelte";
  import Publication from "./Publication.svelte"
  import EtherButton from "./EtherButton.svelte";
  import Modal from './Modal.svelte'
  
  import { getModal } from './Modal.svelte';
  
  export let publish;

  let link, stake, reason = "", status = 'loading', type = "link", 
  extra = { linkText : "", imageLink : "" };

  $: pub = { link, type, extra }


  const onPreviewClick = () => {
    if (document.forms[0].elements[1].reportValidity())
        getModal("preview").open()
  }
  

  const onPublishClick = () => {
    if (!document.forms[0].reportValidity()) return;

    getModal("status").open(() => {
      status = 'loading';
      reason = '';
    });

    publish(link, type, JSON.stringify(extra), stake.toString())
    .then(receipt => {
      console.log(receipt);
      status = "sucess"
  		getModal("pub").close()
  		
    })
    .catch(error => {
      status = 'error';
      reason = error.message
  		getModal("status").open()
    });


  }

  const publicationTypes = [
    { type: "link", text: "Link"},
    { type: "image", text: "Image / Animation" },
    { type: "video", text: "Video"},
    { type: "iframe", text: "Iframe"},
  ]



</script>


<form id="form" action="#" on:submit|preventDefault class="center">
  <ul class="center">

    <li id="typeLi">
      <label for="pubType">Type:</label>
      <select id="pubType" bind:value={type}>
        {#each publicationTypes as pubType}
        <option value={pubType.type}>
          {pubType.text}
        </option>
        {/each}
      </select>
    </li>
    
    <li>
      <input bind:value={link} placeholder="URL of the publication" type="url" required/>
    </li>

    
    { #if type == "link" }

      <li>
        <input bind:value={extra.linkText} placeholder="Text for the link (optional)" type="text"/>
      </li>

    { :else if type == "image"}
      
      <li>
          <input bind:value={extra.imageLink} placeholder="Image link (Optional)" type="url">
      </li>
      
    { /if }

    
  </ul>

  <ul>
    <li>
      <input bind:value={stake} type="number" placeholder="Bet value (ETH)" min="0.001" max="1000" step="0.0001" required/>
    </li>
  </ul>

  <div id="button-group">
    <EtherButton text="Preview" onClick={onPreviewClick} showLogo={false} buttonStyle="margin-right: 3vw;"/>
    <EtherButton text="Publish" onClick={onPublishClick}/>
  </div>

</form>


<Modal id="status">
  <StatusModalContent {status} {reason} />
</Modal>


{ #if pub && pub.link}
<Modal id="preview">
  <div id="preview-content" class="center">
    <Publication { pub } />
  </div>
</Modal>
{ /if }




<style>

  #preview-content {
    min-height: 80vh;
    min-width: 80vw;
  }


  #typeLi {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    width: 100%;
    margin-bottom: 2.8vh;
  }

  #typeLi > label {
    flex-grow: 1;
    margin-left: 1.5vw
  }

  #button-group {
    display: flex;
    margin-top: 2vh;
  }

  :global(#button-group:first-child) {
    margin-right: 3vw;
  }


  label {
    font-size: 2.3vw;
    font-family: sans-serif;
  }


  select {
    padding: 0.7vh 1.8vw;
    border-radius: 4vw;
    border: 0.2vw solid #0a131b;
    background-color: white;
    font-size: 2.1vw;
    flex-grow: 3;
    text-align: center;
  }


  select:focus {
    outline: none;
  }

  input {
    padding: 1.5vh 2vw;
    border-radius: 3vw;
    border: 0.3vw solid #0a131b;
    margin: 2vh auto;
    max-width: 75vw;
    font-size: 2.5vw;
  }

  input:focus {
    border: 0.3vw solid #0a131b;
    box-shadow: 0.0vw 0.0vh 0.9vw rgb(19, 16, 54);
    outline: none;
  }

  input:not(:placeholder-shown):focus:invalid {
    box-shadow: 0.0vw 0.0vh 0.9vw rgb(19, 16, 54), inset 0 0 0.45vw #f00;
  }


  input:not(:placeholder-shown):not(:focus):invalid {
    box-shadow: inset 0 0 0.45vw #f00;
  }


  form {
    flex-direction: column;
    padding: 0 2.1vw
  }

  ul {
    flex-direction: column;
    list-style-type: none;
    padding-left: 0;
    margin: 1vh auto;
  }

  ul:last-of-type {
    margin-bottom: 1.4vh;
  }

  ul:last-of-type input {
    min-width: 22vw;
  }


  @media only screen and (max-width: 650px) {
    
    ul:first-of-type input {
      min-width: 50vw;
    }

    ul:last-of-type input {
      min-width: 35vw;
    }

    label {
      font-size: 2.7vw;
    }

    select {
      font-size: 2.5vw;
    }

    select {
      font-size: 2.5vw;
    }

    input {
      font-size: 3.0vw;
    }


  }




</style>
