defmodule Commanded.PubSub do
  @moduledoc """
  Pub/sub behaviour for use by Commanded to subcribe to and broadcast messages.
  """

  @behaviour Commanded.PubSub

  @doc """
  Return an optional supervisor spec for pub/sub.
  """
  @callback child_spec() :: [:supervisor.child_spec()]

  @doc """
  Subscribes the caller to the PubSub adapter's topic.
  """
  @callback subscribe(atom) :: :ok | {:error, term}

  @doc """
  Broadcasts message on given topic.

    * `topic` - The topic to broadcast to, ie: `"users:123"`
    * `message` - The payload of the broadcast

  """
  @callback broadcast(String.t, term) :: :ok | {:error, term}

  @doc """
  Track the current process under the given `topic`, uniquely identified by
  `key`.
  """
  @callback track(String.t, term) :: :ok | {:error, term}

  @doc """
  List tracked PIDs for a given topic.
  """
  @callback list(String.t) :: [{term, pid}]

  @doc """
  Return an optional supervisor spec for pub/sub.
  """
  @spec child_spec() :: [:supervisor.child_spec()]
  def child_spec, do: pubsub_provider().child_spec()

  @doc """
  Subscribes the caller to the PubSub adapter's topic.
  """
  @callback subscribe(atom) :: :ok | {:error, term}
  def subscribe(topic), do: pubsub_provider().subscribe(topic)

  @doc """
  Broadcasts message on given topic.
  """
  @callback broadcast(String.t, term) :: :ok | {:error, term}
  def broadcast(topic, message), do: pubsub_provider().broadcast(topic, message)

  @doc """
  Track the current process under the given `topic`, uniquely identified by
  `key`.
  """
  @spec track(String.t, term) :: :ok
  def track(topic, key), do: pubsub_provider().track(topic, key)

  @doc """
  List tracked PIDs for a given topic.
  """
  @spec list(String.t) :: [{term, pid}]
  def list(topic), do: pubsub_provider().list(topic)

  @doc """
  Get the configured pub/sub adapter.

  Defaults to a local pub/sub, restricted to running on a single node.
  """
  @spec pubsub_provider() :: module()
  def pubsub_provider do
    case Application.get_env(:commanded, :pubsub, :local) do
      :local -> Commanded.PubSub.LocalRegistry
      other -> other
    end
  end
end
