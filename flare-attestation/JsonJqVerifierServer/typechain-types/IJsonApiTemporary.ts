/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumberish,
  BytesLike,
  FunctionFragment,
  Result,
  Interface,
  ContractRunner,
  ContractMethod,
  Listener,
} from "ethers";
import type {
  TypedContractEvent,
  TypedDeferredTopicFilter,
  TypedEventLog,
  TypedListener,
  TypedContractMethod,
} from "./common";

export declare namespace IJsonApi {
  export type RequestBodyStruct = {
    url: string;
    postprocessJq: string;
    abi_signature: string;
  };

  export type RequestBodyStructOutput = [
    url: string,
    postprocessJq: string,
    abi_signature: string
  ] & { url: string; postprocessJq: string; abi_signature: string };

  export type ResponseBodyStruct = { abi_encoded_data: BytesLike };

  export type ResponseBodyStructOutput = [abi_encoded_data: string] & {
    abi_encoded_data: string;
  };

  export type ResponseStruct = {
    attestationType: BytesLike;
    sourceId: BytesLike;
    votingRound: BigNumberish;
    lowestUsedTimestamp: BigNumberish;
    requestBody: IJsonApi.RequestBodyStruct;
    responseBody: IJsonApi.ResponseBodyStruct;
  };

  export type ResponseStructOutput = [
    attestationType: string,
    sourceId: string,
    votingRound: bigint,
    lowestUsedTimestamp: bigint,
    requestBody: IJsonApi.RequestBodyStructOutput,
    responseBody: IJsonApi.ResponseBodyStructOutput
  ] & {
    attestationType: string;
    sourceId: string;
    votingRound: bigint;
    lowestUsedTimestamp: bigint;
    requestBody: IJsonApi.RequestBodyStructOutput;
    responseBody: IJsonApi.ResponseBodyStructOutput;
  };

  export type ProofStruct = {
    merkleProof: BytesLike[];
    data: IJsonApi.ResponseStruct;
  };

  export type ProofStructOutput = [
    merkleProof: string[],
    data: IJsonApi.ResponseStructOutput
  ] & { merkleProof: string[]; data: IJsonApi.ResponseStructOutput };

  export type RequestStruct = {
    attestationType: BytesLike;
    sourceId: BytesLike;
    messageIntegrityCode: BytesLike;
    requestBody: IJsonApi.RequestBodyStruct;
  };

  export type RequestStructOutput = [
    attestationType: string,
    sourceId: string,
    messageIntegrityCode: string,
    requestBody: IJsonApi.RequestBodyStructOutput
  ] & {
    attestationType: string;
    sourceId: string;
    messageIntegrityCode: string;
    requestBody: IJsonApi.RequestBodyStructOutput;
  };
}

export interface IJsonApiTemporaryInterface extends Interface {
  getFunction(
    nameOrSignature: "proof" | "request" | "response"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "proof",
    values: [IJsonApi.ProofStruct]
  ): string;
  encodeFunctionData(
    functionFragment: "request",
    values: [IJsonApi.RequestStruct]
  ): string;
  encodeFunctionData(
    functionFragment: "response",
    values: [IJsonApi.ResponseStruct]
  ): string;

  decodeFunctionResult(functionFragment: "proof", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "request", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "response", data: BytesLike): Result;
}

export interface IJsonApiTemporary extends BaseContract {
  connect(runner?: ContractRunner | null): IJsonApiTemporary;
  waitForDeployment(): Promise<this>;

  interface: IJsonApiTemporaryInterface;

  queryFilter<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;
  queryFilter<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEventLog<TCEvent>>>;

  on<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  on<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  once<TCEvent extends TypedContractEvent>(
    event: TCEvent,
    listener: TypedListener<TCEvent>
  ): Promise<this>;
  once<TCEvent extends TypedContractEvent>(
    filter: TypedDeferredTopicFilter<TCEvent>,
    listener: TypedListener<TCEvent>
  ): Promise<this>;

  listeners<TCEvent extends TypedContractEvent>(
    event: TCEvent
  ): Promise<Array<TypedListener<TCEvent>>>;
  listeners(eventName?: string): Promise<Array<Listener>>;
  removeAllListeners<TCEvent extends TypedContractEvent>(
    event?: TCEvent
  ): Promise<this>;

  proof: TypedContractMethod<[_proof: IJsonApi.ProofStruct], [void], "view">;

  request: TypedContractMethod<
    [_request: IJsonApi.RequestStruct],
    [void],
    "view"
  >;

  response: TypedContractMethod<
    [_response: IJsonApi.ResponseStruct],
    [void],
    "view"
  >;

  getFunction<T extends ContractMethod = ContractMethod>(
    key: string | FunctionFragment
  ): T;

  getFunction(
    nameOrSignature: "proof"
  ): TypedContractMethod<[_proof: IJsonApi.ProofStruct], [void], "view">;
  getFunction(
    nameOrSignature: "request"
  ): TypedContractMethod<[_request: IJsonApi.RequestStruct], [void], "view">;
  getFunction(
    nameOrSignature: "response"
  ): TypedContractMethod<[_response: IJsonApi.ResponseStruct], [void], "view">;

  filters: {};
}
