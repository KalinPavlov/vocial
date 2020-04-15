import {Socket} from "phoenix"

const pushVote = (el, channel) => {
    channel
        .push('vote', { option_id: el.getAttribute('data-option-id') })
        .receive("ok", res => console.log("You Voted!"))
        .receive("error", res => console.log("Failed to vote:", res));
};

const onJoin = (res, channel) => {
    document.querySelectorAll('.vote-button-manual').forEach(el => {
        el.addEventListener('click', event => {
            event.preventDefault();
            pushVote(el, channel)
        });
    });
    console.log('Joined channel:', res);
};

let socket = new Socket("/socket");

socket.connect()

const enableSocket = document.getElementById('enable-polls-channel');

if (enableSocket) {
    console.log('Inside')
    const pollId = enableSocket.getAttribute('data-poll-id');
    const channel = socket.channel('polls:' + pollId, {})
    channel
        .join()
        .receive("ok", res => onJoin(res, channel))
        .receive("error", res => { console.log("Unable to join", res) })

    document.getElementById('polls-ping').addEventListener('click', () => {
        channel.push('ping')
            .receive("ok", resp => console.log("Received PING response:", resp.message))
            .receive("error", resp => console.log("Error sending PING:", resp));
    });

    channel.on('pong', payload => {
        console.log("The server has been PONG'd and all is well:", payload);
    });
}

export default socket
